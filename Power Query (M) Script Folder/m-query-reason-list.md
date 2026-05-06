# 📂 Reason Mapping & Standardization Script

### 🎯 Business Objective
In Salesforce, "Loss Reasons" are often captured as raw text or multi-select picklists. To create a meaningful **Lost Sales Analysis Dashboard**, these reasons must be:
1.  **Standardized:** Categorized into High-level "Main Reasons" (e.g., Pricing, Product).
2.  **Ordered Logically:** Sorted by the sales stage journey rather than alphabetically.

### ✨ Key Technical Features
*   **Zero-Dependency Portability:** The mapping table is embedded directly into the M script using `Binary.Decompress`. This ensures the Power BI report remains functional without needing external Excel mapping files.
*   **Optimized Sorting Engine:** Used `List.PositionOf` to handle categorical sorting. This is significantly more efficient and easier to maintain than nested `if-else` statements.
*   **Memory Buffering:** Applied `Table.Buffer()` to cache the mapping table in memory, drastically improving the performance of subsequent `Table.NestedJoin` operations.
```powerquery
let
    Source = Salesforce.Data(), // Connected to Salesforce API
    /* ... Data extraction steps ... */
    #"Replaced Value" = Table.ReplaceValue(#"Changed Type"," and Campaign","",Replacer.ReplaceText,{"Main Reason"}),
    
    // Applying Business Logic for Custom Sorting
    #"Added Conditional Column" = Table.AddColumn(#"Replaced Value", "Sort Main Reason by Stage", each 
        if [Main Reason] = "Company" then 1 
        else if [Main Reason] = "Product" then 2 
        else if [Main Reason] = "Pricing" then 3 
        else if [Main Reason] = "Promotion" then 4 
        else if [Main Reason] = "Pre-Sales Service" then 5 
        else if [Main Reason] = "Leasing" then 6 
        else if [Main Reason] = "Delivery" then 7 
        else if [Main Reason] = "After-Sales Service" then 8 
        else "-"
    ),
    
    // Optimize performance by buffering the table
    Custom1 = Table.Buffer(#"Added Conditional Column")
in
    Custom1
