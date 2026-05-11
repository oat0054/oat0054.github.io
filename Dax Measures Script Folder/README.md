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

```dax
Total Lost Amount = SUM('Salesforce_Data'[ExpectedRevenue])
```
Purpose: Serves as the foundational metric for all advanced calculations within the analysis.

Code snippet
Lost Amount YoY % = 
VAR _current = [Total Lost Amount]
VAR _previous = CALCULATE([Total Lost Amount], SAMEPERIODLASTYEAR('Date'[Date]))
RETURN 
DIVIDE(_current - _previous, _previous, 0)
Purpose: Identifies whether the rate of lost opportunities is increasing or decreasing compared to the previous year.

Code snippet
Loss Rate % = 
VAR _total_opp = [Total Won] + [Total Lost Amount]
RETURN 
DIVIDE([Total Lost Amount], _total_opp, 0)
Purpose: A key KPI used to evaluate sales pipeline health and overall market competitiveness.

Code snippet
Rank by Reason = 
RANKX(
    ALL('Salesforce_Data'[Main_Reason]), 
    [Total Lost Amount], , DESC
)
Purpose: Prioritizes the "Root Causes" of losses, allowing management to focus on the most critical issues first.

Code snippet
Dynamic Title = 
"Lost Analysis for: " & SELECTEDVALUE('Salesforce_Data'[Region], "All Regions")
Purpose: Improves user experience by automatically updating visual headers based on selected slicers.

