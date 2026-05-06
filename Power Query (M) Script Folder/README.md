# 🛠️ Power Query (M) Scripts

This folder contains optimized M-Language scripts used to transform and clean the Salesforce Opportunity data.

### 📄 Script Catalog
*   [Opportunity Lost](m-query-opportunity-lost.md) - Focuses on extracting loss reasons and competitor comparisons for lost deals.
*   [Opportunity Won](m-query-opportunity-won.md) - Prepares won deal data for win analysis and KPI tracking.
*   [Won & Lost Combined](m-query-opportunity-won-and-lost.md) - The master query that joins both states for a full funnel view.
*   [Reason List](m-query-opportunity-reason-list.md) - The master query that joins both states for a full funnel view.

### ✨ Optimization Highlights
*   **Performance:** Implemented single-pass record generation to reduce data refresh time.
*   **Security:** Masked all sensitive endpoints and proprietary business logic for public viewing.
# 📂 Reason Mapping & Standardization Script

### 🎯 Business Objective
In Salesforce, "Loss Reasons" are often captured as raw text or multi-select picklists. To create a meaningful **Lost Sales Analysis Dashboard**, these reasons must be:
1.  **Standardized:** Categorized into High-level "Main Reasons" (e.g., Pricing, Product).
2.  **Ordered Logically:** Sorted by the sales stage journey rather than alphabetically.

### ✨ Key Technical Features
*   **Zero-Dependency Portability:** The mapping table is embedded directly into the M script using `Binary.Decompress`. This ensures the Power BI report remains functional without needing external Excel mapping files.
*   **Optimized Sorting Engine:** Used `List.PositionOf` to handle categorical sorting. This is significantly more efficient and easier to maintain than nested `if-else` statements.
*   **Memory Buffering:** Applied `Table.Buffer()` to cache the mapping table in memory, drastically improving the performance of subsequent `Table.NestedJoin` operations.
