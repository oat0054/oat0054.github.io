```powerquery
let
    /* 
       --- 1. Data Extraction & Initial Filtering ---
    */
    Source = Salesforce.Data("https://<YOUR_INSTANCE>.salesforce.com/", [ApiVersion=48]),
    OpportunityData = Source{[Name="Opportunity"]}[Data],
    
    // Filter rows early to optimize performance (Folding)
    FilteredRows = Table.SelectRows(OpportunityData, each 
        ([Department_by_User__c] = "Primary_Business_Unit") and 
        ([StageName] = "Closed Lost") and 
        ([Include_in_Sales_Forecast__c] = true)
    ),
    
    // Select required columns only. This reduces the memory footprint.
    SelectedColumns = Table.SelectColumns(FilteredRows, {
        "Id", "AccountId", "Name", "StageName", "Amount", "Probability", "CloseDate", 
        "NextStep", "IsClosed", "IsWon", "HasOpportunityLineItem", "OwnerId", 
        "CreatedDate", "Loss_Reason__c", "Contract_No__c", "Dept_Name__c", 
        "Province__c", "Winner_Name__c", "Winner_Tin__c", "Won_Reason__c", 
        "Product_Brand_1__c", "Region_by_User__c", "Department_by_User__c", 
        "Internal_Cash_Price__c", "Other_Competitor_Brand__c", "Asset_Serial_Number__c", 
        "Model__c", "Job__c", "Salesman__c",
        "Loss_To_Competitor_1__c", "Loss_To_Competitor_2__c", "Loss_to_Competitor_3__c",
        "Machine_Brand_1__c", "Machine_Brand_2__c", "Machine_Brand_3__c",
        "Machine_Model_1__c", "Machine_Model_2__c", "Machine_Model_3__c",
        "Machine_Unit_1__c", "Machine_Unit_2__c", "Machine_Unit_3__c",
        "Cash_Price_Include_VAT_1__c", "Cash_Price_Include_VAT_2__c", "Cash_Price_Include_VAT_3__c"
        // ... (Include other necessary technical fields)
    }),

    /* --- 2. Single-Pass Record Generation (Logic Optimization) --- */
    AddedCompetitorData = Table.AddColumn(SelectedColumns, "CompData", each 
        let
            isL1 = [Loss_To_Competitor_1__c] = true,
            isL2 = [Loss_To_Competitor_2__c] = true,
            isL3 = [Loss_To_Competitor_3__c] = true,
            
            // Helper function to handle null or empty values
            CheckVal = (mVal, cVal) => if mVal = null or mVal = "" then cVal else mVal,
            
            Brand = if isL1 then CheckVal([Machine_Brand_1__c], [Competitor_Brand_1__c])
                    else if isL2 then CheckVal([Machine_Brand_2__c], [Competitor_Brand_2__c])
                    else if isL3 then CheckVal([Machine_Brand_3__c], [Competitor_Brand_3__c])
                    else null,
                    
            Model = if isL1 then CheckVal([Machine_Model_1__c], [Competitor_Model_1__c])
                    else if isL2 then CheckVal([Machine_Model_2__c], [Competitor_Model_2__c])
                    else if isL3 then CheckVal([Machine_Model_3__c], [Competitor_Model_3__c])
                    else null,
                    
            UnitVal = if isL1 then [Machine_Unit_1__c] 
                      else if isL2 then [Machine_Unit_2__c] 
                      else if isL3 then [Machine_Unit_3__c] 
                      else 1, // Default to 1 if not specified
                      
            Price = if isL1 then [Cash_Price_Include_VAT_1__c] 
                    else if isL2 then [Cash_Price_Include_VAT_2__c] 
                    else if isL3 then [Cash_Price_Include_VAT_3__c] 
                    else null
        in
            [
                Competitor = Brand,
                CompetitorModel = Model,
                units = UnitVal,
                CompetitorPrice = Price
            ]
    ),
    
    // Expand record to flat columns
    ExpandedCompData = Table.ExpandRecordColumn(AddedCompetitorData, "CompData", 
        {"Competitor", "CompetitorModel", "units", "CompetitorPrice"}, 
        {"Competitor_Final", "Competitor_Model_Final", "Units_Final", "Competitor_Price_Final"}
    ),

    /* --- 3. Data Transformation & Merging --- */
    // Split multi-select picklist for Lost Reasons
    SplitLostReason = Table.ExpandListColumn(
        Table.TransformColumns(ExpandedCompData, {
            {"Loss_Reason__c", Splitter.SplitTextByDelimiter(";", QuoteStyle.None), type text}
        }), "Loss_Reason__c"
    ),
    
    // Left Join with Reference Tables
    MergedReasonList = Table.NestedJoin(SplitLostReason, {"Loss_Reason__c"}, #"Ref_Reason_List", {"Reason_Key"}, "Reason_Detail", JoinKind.LeftOuter),
    ExpandedReason = Table.ExpandTableColumn(MergedReasonList, "Reason_Detail", {"Main_Reason", "Sub_Reason"}),
    
    /* --- 4. Final Pricing Evaluation (Null Coalescing Logic) --- */
    AddedPricingCalculation = Table.AddColumn(ExpandedReason, "Calculated_Values", each 
        let
            Internal_Total = [Internal_Cash_Price__c], // Replace with your internal pricing logic
            Competitor_Total = ([Competitor_Price_Final] ?? 0) * ([Units_Final] ?? 1),
            Estimated_Deal_Value = Internal_Total ?? Competitor_Total
        in
            [
                Final_Internal_Price = Internal_Total,
                Final_Competitor_Price = Competitor_Total,
                Deal_Value = Estimated_Deal_Value
            ]
    ),
    
    /* --- 5. Cleanup & Final Schema --- */
    ExpandedFinal = Table.ExpandRecordColumn(AddedPricingCalculation, "Calculated_Values", 
        {"Final_Internal_Price", "Final_Competitor_Price", "Deal_Value"}),
        
    FinalOutput = Table.TransformColumnTypes(ExpandedFinal, {
        {"Final_Internal_Price", Currency.Type}, 
        {"Final_Competitor_Price", Currency.Type}, 
        {"Deal_Value", Currency.Type}
    })
in
    FinalOutput
