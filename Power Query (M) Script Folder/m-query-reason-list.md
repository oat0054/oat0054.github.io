# Reason Mapping

### Business Objective
In Salesforce, "Loss Reasons" are often captured as raw text or multi-select picklists. To create a meaningful **Lost Deals Analysis Dashboard**, these reasons must be:
*  **Standardized:** Categorized into High-level "Main Reasons" (e.g., Pricing, Product).
*  **Ordered Logically:** Sorted by the sales stage journey rather than alphabetically.

### Key Technical Features
*   **No Extra Files Needed (Self-Contained):** The mapping data is built directly into the script. This ensures the Power BI report works perfectly without needing a separate Excel file.
*   **Better Sorting Method:** I used List.PositionOf to rank the categories. This method is much faster and easier to update than using many if-else lines.
*   **Faster Loading:** I used Table.Buffer() to store the data in memory. This significantly speeds up the process when merging this table with other data.

```powerquery
let
    // --- 1. Mapping Table Setup  ---
   Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("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", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Reason TH" = _t, Sub_Reason = _t, #"Main Reason" = _t]),

    // --- 2. Data Cleaning ---
    RemoveSuffix = Table.ReplaceValue(Source, " and Campaign", "", Replacer.ReplaceText, {"Main Reason"}),

    // --- 3.Sorting order for sales analysis stages ---
    SortOrder = {"Company", "Product", "Pricing", "Promotion", "Pre-Sales Service", "Leasing", "Delivery", "After-Sales Service"},
    
    AddSortColumn = Table.AddColumn(RemoveSuffix, "Sort Main Reason by Stage", each 
        let 
            Position = List.PositionOf(SortOrder, [Main Reason])
        in 
            if Position <> -1 then Position + 1 else null, 
        Int64.Type
    ),
    // --- 4. Optimization ---
    FinalOutput = Table.Buffer(AddSortColumn)
in
    FinalOutput
```
<img width="1095" height="871" alt="image" src="https://github.com/user-attachments/assets/d95642fc-6bc4-4137-b315-3cd95f22de5a" />


[⬅️ Back to Main Power Query (M) Scripts](https://github.com/oat0054/oat0054.github.io/blob/main/Power%20Query%20(M)%20Script%20Folder/README.md)
