# Opportunity Won and Lost (Master Table)


### Business Objective

1. **Full Sales Picture:** I merged both Won and Lost deals into one master table so we can see the entire sales pipeline and overall performance in one place.

2. **Clean & Consistent Data:** I fixed messy labels for customer types and regions to make sure all charts and filters in the report are accurate and easy to read.

### Key Technical Features

* **Smart Data Linking:** I connected the main table to several "Lookup" tables to automatically pull in sorting orders and extra details, keeping the dataset organized.

* **Sales Effort Tracking:** I added a smart check called `IsAttempt` to see if a quote was sent before the deal closed. This helps measure the actual effort put into each sales opportunity.

---

<details>
<summary><b>View M Language Script (Click to expand)</b></summary>
  
<img width="1794" height="1061" alt="Zw0dg37Gfd" src="https://github.com/user-attachments/assets/ca8a08fd-1869-49e5-ab54-362842acc69f" />

</details>

```powerquery
let
    // --- 1. Combine Data Sources ---
    Source = Table.Combine({#"Opportunity Lost", #"Opportunity Won"}),

    // --- 2. Clean & Standardize Categorical Data  ---
    
    CleanedCategories = Table.TransformColumns(Source, {
        {"Customer_Type_as_of_Close_Date__c", each if _ = "Competitor Mixed" then "Competitor" else if _ = null or _ = "No Machine" or _ = "Unknown" or _ = "0" then "New" else _, type text},
        {"Region_by_User__c", each if _ = "HQ Branch" then "HQ" else if _ = "Region-A Low" then "RegA-L" else if _ = "Region-A Up" then "RegA-U" else _, type text}
    }),

    // --- 3. Feature Engineering ---
    AddedHasCompetitor = Table.AddColumn(CleanedCategories, "Has Competitor?", each if [Competitor] = "No Competitor" then "No Competitor" else "With Competitor", type text),

    // --- 4. Relational Merges (Consolidated Lookups) ---
    // Lookup: Sort Cust Type (Renamed inline during expansion)
    MergedSortCust = Table.NestedJoin(AddedHasCompetitor, {"Customer_Type_as_of_Close_Date__c"}, #"Sort Cust Type", {"Customer Type"}, "Sort Cust Type", JoinKind.LeftOuter),
    ExpandedSortCust = Table.ExpandTableColumn(MergedSortCust, "Sort Cust Type", {"Sort Cust Type"}, {"Sort Cust Type"}),

    // Lookup: Brand Sort
    MergedBrandSort = Table.NestedJoin(ExpandedSortCust, {"Competitor"}, #"Brand Sort", {"Competitor"}, "Brand Sort", JoinKind.LeftOuter),
    ExpandedBrandSort = Table.ExpandTableColumn(MergedBrandSort, "Brand Sort", {"Sort"}, {"Sort"}),
    ReplacedBrandSortNulls = Table.ReplaceValue(ExpandedBrandSort, null, 12, Replacer.ReplaceValue, {"Sort"}),
    ChangedBrandSortType = Table.TransformColumnTypes(ReplacedBrandSortNulls, {{"Sort", Int64.Type}}),

    // Lookup: Quote Data
    MergedQuote = Table.NestedJoin(ChangedBrandSortType, {"Id"}, Quote, {"OpportunityId"}, "Quote", JoinKind.LeftOuter),
    ExpandedQuote = Table.ExpandTableColumn(MergedQuote, "Quote", {"CreatedDate", "OpportunityId", "Payment_Type__c"}, {"Quote.CreatedDate", "Quote.OpportunityId", "Internal Payment Type"}),

    // --- 5. Final Calculations & Formatting ---
    // Simplified boolean logic (evaluates directly to true/false without verbose IF statements)
    AddedIsAttempt = Table.AddColumn(ExpandedQuote, "IsAttempt", each ([Quote.OpportunityId] <> null and [Quote.CreatedDate] <= [CloseDate]), type logical),

    FinalColumns = Table.ReorderColumns(AddedIsAttempt, {
        "Id", "AccountId", "Name", "StageName", "Amount", "Probability", "CloseDate", "NextStep", "IsClosed", "IsWon", "HasOpportunityLineItem", "Pricebook2Id", "OwnerId", "CreatedDate", "CreatedById", "SyncedQuoteId", "Loss_Reason__c", "Cash_Price_Include_VAT_1__c", "Cash_Price_Include_VAT_2__c", "Cash_Price_Include_VAT_3__c", "Contract_Date__c", "Contract_Finish_Date__c", "Contract_No__c", "Contract__c", "Dept_Name__c", "Dept_Sub_Name__c", "District__c", "Down_Payment_1__c", "Down_Payment_2__c", "Down_Payment_3__c", "Installment_period_Month_1__c", "Installment_period_Month_2__c", "Installment_period_Month_3__c", "Int_Rate_1__c", "Int_Rate_2__c", "Int_Rate_3__c", "Account_Created_By__c", "CheckActualVisit__c", "X1_1Lost__c", "Lost_Reason__c", "Number_of_Competitor__c", "Opportunity_Number__c", "Opportunity_Rate__c", "Province__c", "Special_Condition_Promotion_1__c", "Special_Condition_Promotion_2__c", "Special_Condition_Promotion_3__c", "Sub_District__c", "Term_of_Payment_1__c", "Term_of_Payment_2__c", "Term_of_Payment_3__c", "Transaction_Date__c", "Winner_Name__c", "Winner_Tin__c", "Won_Reason__c", "Product_Brand_1__c", "Asset__c", "Region_by_User__c", "Department_by_User__c", "Internal_Cash_Price__c", "Internal_Down_Payment__c", "Internal_Installment_Period__c", "Internal_Int_Rate__c", "Internal_Special_Condition__c", "Other_Competitor_Brand__c", "Asset_Serial_Number__c", "Model__c", "Job__c", "Customer_Type_as_of_Close_Date__c", "Lost_Reason_Details__c", "General_Manager_Name__c", "Manager_Name__c", "Region__c", "Won_Reason_Details__c", "Internal_model__c", "Salesman__c", "Competitor", "Competitor Model", "Sub_Reason", "Main Reason", "Sort Main Reason by Stage", "Internal Model", "Product Category", "Product Class", "units", "Internal Total Price", "Competitor Total Price", "Deal Value", "Sort Cust Type", "Has Competitor?", "Quote.CreatedDate", "Quote.OpportunityId", "IsAttempt", "Sort", "Internal Payment Type", "Competitor Payment Type"
    })
in
    FinalColumns

