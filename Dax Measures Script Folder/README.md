# 🔢 DAX Measures & Business Logic

This folder documents the core DAX formulas used to drive the interactive visualizations.

### Key Measures
*   **[Win Rate %](dax-win-rate.md)**: Calculated based on the ratio of Won vs. Total opportunities.
*   **[Loss Analysis](dax-loss-analysis.md)**: Logic to identify market gaps and competitor strongholds.
*   **[Forecasting](dax-forecasting.md)**: Probability-weighted revenue projection scripts.

### Technical Approach
*   **Variables (VAR):** Used extensively for better performance and code readability.
*   **DAX Studio:** All measures were performance-tested using DAX Stu

### Implementation Details (DAX Code)
The following measures demonstrate the technical logic used to transform raw CRM data into strategic business insights:

<br>

```dax
Total Value = SUMX(VALUES('Opportunity Won and Lost'[Id]),
                CALCULATE(MAX('Opportunity Won and Lost'[Deal Value])))

Total Lost Value = CALCULATE([Total Value], 'Opportunity Won and Lost'[StageName] = "Closed Lost")
```
Purpose: Serves as the foundational metric for all advanced calculations within the analysis

<br>

```dax
Loss Rate % = DIVIDE([Lost Deals], [Total Deals], 0)
```
Purpose: A key KPI used to evaluate sales pipeline health and overall market competitiveness.

<br>

```dax
Total Units Lost (Prev Period) = 
VAR _SelectedDates = ALLSELECTED('Calendar Days')
VAR _MinDate = MINX(_SelectedDates, 'Calendar Days'[Date])
VAR _MaxDate = MAXX(_SelectedDates, 'Calendar Days'[Date])

-- 1. Count how many months are currently selected in the Slicer
VAR _MonthCount = 
    COUNTROWS(
        DISTINCT(
            SELECTCOLUMNS(
                FILTER(ALL('Calendar Days'), 'Calendar Days'[Date] >= _MinDate && 'Calendar Days'[Date] <= _MaxDate),
                "MonthYear", 'Calendar Days'[Month] & 'Calendar Days'[Year]
            )
        )
    )

-- 2. Shift the time period back by the exact number of months counted
RETURN
CALCULATE(
    [Total units lost],
    DATEADD('Calendar Days'[Date], -_MonthCount, MONTH)
)

Deals Lost vs Prev Period = 
[Lost Deals] - [Total Deals Lost (Prev Period)]
```
Purpose: It provides a Fair Comparison. If you are looking at a 3-month trend, this formula automatically compares it to the previous 3 months, making your analysis much more accurate.

<br>

```dax
Rank by Reason = 
VAR CurrentValue = [Total Lost Value] -- Captures the value of the current row for comparison
RETURN
IF (
    ISINSCOPE('Opportunity Won and Lost'[Main Reason]), -- Ensures ranking only triggers at the Reason level
    RANKX(
        ALLSELECTED(
            'Opportunity Won and Lost'[Main Reason], 
            'Opportunity Won and Lost'[Sort Main Reason by Stage] -- Clears filters on both display and sort columns
        ),
        [Total Lost Value], -- The measure used to determine the rank
        CurrentValue,       -- The value to be ranked
        DESC,               
        Dense               -- Ensures sequential ranking (1, 2, 3...) even with ties
    ),
    BLANK() -- Returns blank for total rows to keep the report clean
)
```
Purpose: 




