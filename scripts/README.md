# 🛠️ Power Query (M) Scripts

This folder contains optimized M-Language scripts used to transform and clean the Salesforce Opportunity data.

### 📄 Script Catalog
*   [Opportunity Lost](m-query-opportunity-lost.md) - Focuses on extracting loss reasons and competitor comparisons for lost deals.
*   [Opportunity Won](m-query-opportunity-won.md) - Prepares won deal data for revenue analysis and KPI tracking.
*   [Won & Lost Combined](m-query-opportunity-won-and-lost.md) - The master query that joins both states for a full funnel view.

### ✨ Optimization Highlights
*   **Performance:** Implemented single-pass record generation to reduce data refresh time.
*   **Security:** Masked all sensitive endpoints and proprietary business logic for public viewing.
