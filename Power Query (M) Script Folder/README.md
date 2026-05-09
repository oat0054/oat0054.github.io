# Power Query (M) Scripts

This folder contains optimized M-Language scripts used to transform and clean the Salesforce Opportunity data.

### Script Catalog
*   [Calendar Days](m-query-calendar-days.md) - Generates an date dimension with custom Fiscal Year and time-intelligence attributes.
*   [Opportunity Lost](m-query-opportunity-lost.md) - Focuses on extracting loss reasons and competitor comparisons for lost deals.
*   [Opportunity Won](m-query-opportunity-won.md) - Prepares won deal data for win analysis and KPI tracking.
*   [Won & Lost Combined](m-query-opportunity-won-and-lost.md) - The master query that joins both states for a full funnel view.
*   [Reason List](m-query-reason-list.md) - Categorizes multi-select picklists into High-level "Main Reasons".

### Optimization Highlights
*   **Dynamic Relative Logic:** Automatically calculates the difference between the data date and today's date to categorize months dynamically
*   **Performance:** Implemented single-pass record generation to reduce data refresh time.
*   **Security:** Masked all sensitive endpoints and proprietary business logic for public viewing.




[⬅️ Back to Main Portfolio](../README.md)
