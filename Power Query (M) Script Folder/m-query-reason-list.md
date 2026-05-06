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
