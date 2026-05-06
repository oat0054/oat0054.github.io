```powerquery
let
    // --- 1. Data Extraction & Early Filtering ---
    // Source connection string and API version are masked for data privacy
    Source = Salesforce.Data("https://[MASKED_CRM_URL]/", [ApiVersion=XX]),
    OpportunityData = Source{[Name="Opportunity"]}[Data],
    
    // Consolidated filtering steps to reduce data volume.
    FilteredRows = Table.SelectRows(OpportunityData, each 
        ([Department_by_User__c] = "Machine Sale") and 
        ([IsClosed] = true) and 
        ([Include_in_Sales_Forecast__c] = true) and 
        ([StageName] = "Closed Won")
    ),
    
    // Excluded unnecessary columns ("Type", "Budget_Year__c") directly during selection
    // to bypass the need for an additional 'Table.RemoveColumns' step.
    // Note: Custom field names have been genericized (e.g., 'Internal_...') to protect company privacy.
    SelectedColumns = Table.SelectColumns(FilteredRows, {
        "Id", "AccountId", "Name", "StageName", "Amount", "Probability", "CloseDate", 
        "NextStep", "IsClosed", "IsWon", "HasOpportunityLineItem", "Pricebook2Id", "OwnerId", 
        "CreatedDate", "CreatedById", "SyncedQuoteId", "Loss_Reason__c", 
        "Cash_Price_Include_VAT_1__c", "Cash_Price_Include_VAT_2__c", "Cash_Price_Include_VAT_3__c", 
        "Contract_Date__c", "Contract_Finish_Date__c", "Contract_No__c", "Contract__c", "Dept_Name__c", 
        "Dept_Sub_Name__c", "District__c", "Down_Payment_1__c", "Down_Payment_2__c", "Down_Payment_3__c", 
        "Installment_period_Month_1__c", "Installment_period_Month_2__c", "Installment_period_Month_3__c", 
        "Int_Rate_1__c", "Int_Rate_2__c", "Int_Rate_3__c", "Account_Created_By__c", "CheckActualVisit__c", 
        "X1_1Lost__c", "Lost_Reason__c", "Machine_Brand_1__c", "Machine_Brand_2__c", "Machine_Brand_3__c", 
        "Machine_Model_1__c", "Machine_Model_2__c", "Machine_Model_3__c", "Machine_Unit_1__c", "Machine_Unit_2__c", 
        "Machine_Unit_3__c", "Number_of_Competitor__c", "Opportunity_Number__c", "Opportunity_Rate__c", 
        "Province__c", "Special_Condition_Promotion_1__c", "Special_Condition_Promotion_2__c", 
        "Special_Condition_Promotion_3__c", "Sub_District__c", "Term_of_Payment_1__c", "Term_of_Payment_2__c", 
        "Term_of_Payment_3__c", "Transaction_Date__c", "Winner_Name__c", "Winner_Tin__c", "Won_Reason__c", 
        "Product_Brand_1__c", "Asset__c", "Region_by_User__c", "Department_by_User__c", "Internal_Cash_Price__c", 
        "Internal_Down_Payment__c", "Internal_Installment_Period__c", "Internal_Int_Rate__c", "Internal_Special_Condition__c", 
        "Other_Competitor_Brand__c", "Competitor_proposal__c", "Competitor_Brand_1__c", "Competitor_Model_1__c", 
        "Competitor_Brand_2__c", "Competitor_Brand_3__c", "Competitor_Model_2__c", "Competitor_Model_3__c", 
        "Loss_To_Competitor_1__c", "Loss_To_Competitor_2__c", "Loss_to_Competitor_3__c", "Asset_Serial_Number__c", 
        "Model__c", "Job__c", "Customer_Type_as_of_Close_Date__c", "Lost_Reason_Details__c", "General_Manager_Name__c", 
        "Manager_Name__c", "Region__c", "Won_Reason_Details__c", "Internal_model__c", "Salesman__c"
    }),

    // --- 2. Single-Pass Record Generation (Competitor Attributes) ---
    // Grouping multiple conditional checks into a single record evaluation.
    // Utilized a custom helper function to replace verbose nested IF statements.
    AddedCompetitorData = Table.AddColumn(SelectedColumns, "CompData", each 
        let
            // Helper function: Returns the first non-null/non-empty string from a given list
            GetFirstText = (lst as list) => try List.First(List.Select(lst, each _ <> null and Text.From(_) <> "")) otherwise null,
            
            Brand = GetFirstText({[Machine_Brand_1__c], [Machine_Brand_2__c], [Machine_Brand_3__c], [Competitor_Brand_1__c], [Competitor_Brand_2__c], [Competitor_Brand_3__c]}) ?? "No Competitor",
            Model = GetFirstText({[Machine_Model_1__c], [Machine_Model_2__c], [Machine_Model_3__c], [Competitor_Model_1__c], [Competitor_Model_2__c], [Competitor_Model_3__c]}) ?? "No Competitor",
            
            CompPrice = if [Loss_To_Competitor_1__c] = true then [Cash_Price_Include_VAT_1__c] else if [Loss_To_Competitor_2__c] = true then [Cash_Price_Include_VAT_2__c] else if [Loss_to_Competitor_3__c] = true then [Cash_Price_Include_VAT_3__c] else null,
            CompPayType = if [Loss_To_Competitor_1__c] = true then [Term_of_Payment_1__c] else if [Loss_To_Competitor_2__c] = true then [Term_of_Payment_2__c] else if [Loss_to_Competitor_3__c] = true then [Term_of_Payment_3__c] else null
        in
            [
                Competitor = Brand,
                CompetitorModel = Model,
                CompetitorTotalPrice = CompPrice,
                CompetitorPaymentType = CompPayType
            ]
    ),
    ExpandedCompData = Table.ExpandRecordColumn(AddedCompetitorData, "CompData", 
        {"Competitor", "CompetitorModel", "CompetitorTotalPrice", "CompetitorPaymentType"}, 
        {"Competitor", "Competitor Model", "Competitor Total Price", "Competitor Payment Type"}
    ),

    // --- 3. Data Transformation & Relational Merges ---
    SplitWonReason = Table.ExpandListColumn(Table.TransformColumns(ExpandedCompData, {{"Won_Reason__c", Splitter.SplitTextByDelimiter(";", QuoteStyle.None), type text}}), "Won_Reason__c"),
    
    MergedReasonList = Table.NestedJoin(SplitWonReason, {"Won_Reason__c"}, #"Reason List", {"Reason TH"}, "Reason List", JoinKind.LeftOuter),
    ExpandedReasonList = Table.ExpandTableColumn(MergedReasonList, "Reason List", {"Sub_Reason", "Main Reason", "Sort Main Reason by Stage"}),
    
    // Handled null replacement for 'Main Reason'
    CleanedMainReason = Table.ReplaceValue(ExpandedReasonList, null, "Unspecified", Replacer.ReplaceValue, {"Main Reason"}),
    
    MergedOppProduct = Table.NestedJoin(CleanedMainReason, {"Id"}, #"Opportunity Product", {"OpportunityId"}, "Opportunity Product", JoinKind.LeftOuter),
    ExpandedOppProduct = Table.ExpandTableColumn(MergedOppProduct, "Opportunity Product", {"Internal Model", "Product Category", "Product Class", "Quantity", "TotalPrice"}),

    // --- 4. Calculations (Units, Filtering, and Deal Value) ---
    // Filter out rows with invalid Total Prices immediately after expansion
    FilteredValidPrices = Table.SelectRows(ExpandedOppProduct, each ([TotalPrice] <> null)),
    
    // Generated 'units' and duplicate 'Deal Value' columns in a single processing step
    AddedFinalMetrics = Table.AddColumn(FilteredValidPrices, "FinalMetrics", each 
        let
            UnitVal = [Quantity] ?? 1,
            DealVal = [TotalPrice]
        in
            [
                units = UnitVal,
                InternalTotalPrice = DealVal,
                DealValue = DealVal
            ]
    ),
    ExpandedFinalMetrics = Table.ExpandRecordColumn(AddedFinalMetrics, "FinalMetrics", {"units", "InternalTotalPrice", "DealValue"}, {"units", "Internal Total Price", "Deal Value"}),

    // --- 5. Clean Up, Reordering, and Type Casting ---
    FinalColumns = Table.SelectColumns(ExpandedFinalMetrics, {
        "Id", "AccountId", "Name", "StageName", "Amount", "Probability", "CloseDate", "NextStep", 
        "IsClosed", "IsWon", "HasOpportunityLineItem", "Pricebook2Id", "OwnerId", "CreatedDate", 
        "CreatedById", "SyncedQuoteId", "Loss_Reason__c", "Cash_Price_Include_VAT_1__c", 
        "Cash_Price_Include_VAT_2__c", "Cash_Price_Include_VAT_3__c", "Contract_Date__c", 
        "Contract_Finish_Date__c", "Contract_No__c", "Contract__c", "Dept_Name__c", "Dept_Sub_Name__c", 
        "District__c", "Down_Payment_1__c", "Down_Payment_2__c", "Down_Payment_3__c", 
        "Installment_period_Month_1__c", "Installment_period_Month_2__c", "Installment_period_Month_3__c", 
        "Int_Rate_1__c", "Int_Rate_2__c", "Int_Rate_3__c", "Account_Created_By__c", "CheckActualVisit__c", 
        "X1_1Lost__c", "Lost_Reason__c", "Number_of_Competitor__c", "Opportunity_Number__c", 
        "Opportunity_Rate__c", "Province__c", "Special_Condition_Promotion_1__c", "Special_Condition_Promotion_2__c", 
        "Special_Condition_Promotion_3__c", "Sub_District__c", "Term_of_Payment_1__c", "Term_of_Payment_2__c", 
        "Term_of_Payment_3__c", "Transaction_Date__c", "Winner_Name__c", "Winner_Tin__c", "Won_Reason__c", 
        "Product_Brand_1__c", "Asset__c", "Region_by_User__c", "Department_by_User__c", "Internal_Cash_Price__c", 
        "Internal_Down_Payment__c", "Internal_Installment_Period__c", "Internal_Int_Rate__c", "Internal_Special_Condition__c", 
        "Other_Competitor_Brand__c", "Asset_Serial_Number__c", "Model__c", "Job__c", "Customer_Type_as_of_Close_Date__c", 
        "Lost_Reason_Details__c", "General_Manager_Name__c", "Manager_Name__c", "Region__c", "Won_Reason_Details__c", 
        "Internal_model__c", "Salesman__c", "Competitor", "Competitor Model", "Sub_Reason", "Main Reason", 
        "Sort Main Reason by Stage", "Internal Model", "Product Category", "Product Class", "units", 
        "Internal Total Price", "Competitor Total Price", "Deal Value", "Competitor Payment Type"
    }),
    
    // Applying data types
    FinalTypes = Table.TransformColumnTypes(FinalColumns, {
        {"units", Int64.Type}, 
        {"Internal Total Price", Int64.Type}, 
        {"Competitor Total Price", Int64.Type}, 
        {"Deal Value", Int64.Type}
    })
in
    FinalTypes
