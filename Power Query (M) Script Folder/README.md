# Power Query (M) Scripts

This folder contains optimized M-Language scripts used to transform and clean the Salesforce Opportunity data.

### Script Catalog
*   [Calendar Days](m-query-calendar-days.md) - Generates an date dimension with custom Fiscal Year and time-intelligence attributes.
*   [Lost Deals](m-query-opportunity-lost.md) - Focuses on extracting loss reasons, competitor comparisons, and value estimation for lost opportunities.
*   [Won Deals](m-query-opportunity-won.md) - Prepares success data by linking deals to machine models and identifying key winning factors.
*   [Master Sales Table](m-query-opportunity-won-and-lost.md) - The final master query that joins Won and Lost data for a complete sales funnel view.
*   [Reason Mapping](m-query-reason-list.md) - A self-contained mapping script that categorizes messy multi-select picklists into standardized "Main Reasons".

### Optimization Highlights
*   **Dynamic Relative Logic:** Automatically calculates the difference between the data date and today's date to categorize months dynamically
*   **Performance:** Implemented single-pass record generation to reduce data refresh time.
*   **Security:** Masked all sensitive endpoints and proprietary business logic for public viewing.




[⬅️ Back to Main Portfolio](../README.md)

# ⚡ Power Query (M) Scripts

This folder contains optimized M-Language scripts used to transform and clean Salesforce Opportunity data. These scripts are designed for high performance, maintainability, and clear business insights.

### 📂 Script Catalog

* **[Calendar Days](m-query-calendar-days.md)** - Generates a comprehensive date dimension with custom Fiscal Year (April start) and optimized relative month logic.
* **[Lost Deals](m-query-opportunity-lost.md)** - Focuses on extracting loss reasons, competitor comparisons, and value estimation for lost opportunities.
* **[Won Deals](m-query-opportunity-won.md)** - Prepares success data by linking deals to machine models and identifying key winning factors.
* **[Master Sales Table](m-query-opportunity-won-and-lost.md)** - The final master query that joins Won and Lost data for a complete sales funnel view.
* **[Reason Mapping](m-query-reason-list.md)** - A self-contained mapping script that categorizes messy multi-select picklists into standardized "Main Reasons".

---

### 🚀 Optimization Highlights

Each script in this project implements a specific optimization strategy to ensure the Data Pipeline is efficient and reliable:

* **[Automation] Auto-Updating Time Filters (Calendar Days):** Automatically identifies "This Month" or "Last Month" based on today’s date. This ensures the report is always current without needing manual filter updates.
* **[Reliability] Built-in Reference Data (Reason List):** Embedded the mapping data directly into the script. This prevents "Broken Link" errors and ensures the report remains fully functional without needing external Excel files.
* **[Performance] Efficient Data Loading (Lost Deals):** Filters rows and selects only necessary columns at the very first step. This reduces memory footprint and speeds up the data retrieval process from Salesforce.
* **[Coding] Clean & Reusable Code (Won Deals):** Developed a custom helper function (`GetFirstText`) to handle multiple data checks at once. This makes the script much easier to read, manage, and update.
* **[Analytics] Smart Effort Tracking (Master Table):** Added automatic logic (like the `IsAttempt` flag) to track if a quote was sent before a deal closed. This turns raw data into useful insights about the sales team's actual effort.

---

### 🔒 Security & Privacy
To protect proprietary business information, all scripts in this repository have been sanitized:
* **Connection Strings:** Salesforce URL and API versions are masked.
* **Field Names:** Custom internal field names have been genericized.
* **Data Privacy:** All specific customer and competitor pricing data shown in previews are dummy data for demonstration purposes only.

---

### 🔝 Navigation
* [⬅️ Back to Main Portfolio](../../README.md)
* [📊 Move to DAX Measures Library](../DAX/README.md)
