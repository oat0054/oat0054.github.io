```powerquery
let
    // --- 1. Setup Parameters ---
    StartDate = #date(2021, 4, 1),
    NumberOfDays = 2555, // Approximately 7 years
    
    // Pre-calculate current YearMonth once to optimize relative month logic
    CurrentDate = Date.StartOfMonth(DateTime.Date(DateTime.LocalNow())),
    CurrentYearMonth = (Date.Year(CurrentDate) * 100) + Date.Month(CurrentDate),

    SourceList = List.Dates(StartDate, NumberOfDays, #duration(1, 0, 0, 0)),
    TableFromList = Table.FromList(SourceList, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
    ChangedDateType = Table.TransformColumnTypes(TableFromList, {{"Date", type date}}),

    // --- 2. Single-Pass Attribute Generation (Performance Optimization) ---
    // Instead of multiple AddColumn steps, we generate a record for each row
    AddAttributes = Table.AddColumn(ChangedDateType, "Attributes", each 
        let
            // Base Date Components
            RowDate = [Date],
            YearNum = Date.Year(RowDate),
            MonthNum = Date.Month(RowDate),
            MonthName = Date.MonthName(RowDate),
            
            // Relative Month Logic
            YearMonthInt = (YearNum * 100) + MonthNum,
            Diff = YearMonthInt - CurrentYearMonth,
            MonthType = if Diff = 0 then "This Month" 
                        else if Diff = 1 then "Next Month" 
                        else if Diff = -1 then "Previous Month" 
                        else if Diff < -1 then "Past Month" 
                        else "Future Month",

            // Fiscal Year Logic (Starting April)
            // If Month is Jan-Mar (1-3), FY is previous year
            FiscalYear = if MonthNum >= 4 then YearNum else YearNum - 1,
            FiscalMonthSort = if MonthNum >= 4 then MonthNum - 3 else MonthNum + 9,
            FiscalQuarter = "Q" & Text.From(Number.IntegerDivide(FiscalMonthSort - 1, 3) + 1)
        in
            [
                Year = YearNum,
                Month = MonthNum,
                MonthName = MonthName,
                MonthShort = Text.Start(MonthName, 3),
                MonthYear = Text.Start(MonthName, 3) & "-" & Text.From(YearNum),
                StartOfMonth = Date.StartOfMonth(RowDate),
                EndOfMonth = Date.EndOfMonth(RowDate),
                YearMonth = YearMonthInt,
                MonthType = MonthType,
                FiscalYear = FiscalYear,
                FiscalMonthSort = FiscalMonthSort,
                Quarter = FiscalQuarter
            ]
    ),

    // --- 3. Expansion & Cleanup ---
    ExpandedAttributes = Table.ExpandRecordColumn(AddAttributes, "Attributes", 
        {"Year", "Month", "MonthName", "MonthShort", "MonthYear", "StartOfMonth", "EndOfMonth", "YearMonth", "MonthType", "FiscalYear", "FiscalMonthSort", "Quarter"}
    ),
    
    // Sort and finalize data types
    SortedRows = Table.Sort(ExpandedAttributes, {{"Date", Order.Descending}}),
    FinalTable = Table.TransformColumnTypes(SortedRows, {
        {"Year", Int64.Type}, {"Month", Int64.Type}, {"YearMonth", Int64.Type}, 
        {"FiscalYear", Int64.Type}, {"FiscalMonthSort", Int64.Type}, {"StartOfMonth", type date}, {"EndOfMonth", type date}
    })
in
    FinalTable
