# Calendar Days (Date Table)
### Business Objective

1. **Aligned with the Fiscal Year:** I set the calendar to start in April, matching company's financial reporting cycle.

2. **Relative Time Filtering:** Easily filtering data by "This Month", "Past Month" so Users don't have to manually pick dates.

### Key Technical Features
* **Optimized for Performance:** Instead of adding columns one by one (which can slow things down), I used a "Record" technique to calculate everything in one pass. This makes the data refresh much faster.

* **Dynamic Relative Logic:** Automatically calculates the difference between the data date and today's date to categorize months dynamically

  

<details>
<summary><b>View M Language Script (Click to expand)</b></summary>
  
<img width="1612" height="1031" alt="ihsECNkDoV" src="https://github.com/user-attachments/assets/908ed035-0a5f-4a49-8836-54586eff8e1f" />

</details>

### Result

<img width="1464" height="497" alt="PBIDesktop_9QW60Psg8o" src="https://github.com/user-attachments/assets/1c0df2e9-0e9d-47be-b34f-da8791f12310" />

---
###  Related Scripts in this Project
* [ Opportunity Analysis Logic](./m-query-opportunity.md) – Script for managing Won/Lost tables.
* [ Reason Mapping Standardization](./m-query-reason-mapping.md) – Categorizing and grouping sales reasons.
* [ DAX Measures Library](../DAX/README.md) – Collection of all KPI calculations and measures.
---

###  Navigation
* [ Return to Project Overview](../README.md)
* [ Back to Main Power Query (M) Scripts](https://github.com/oat0054/oat0054.github.io/blob/main/Power%20Query%20(M)%20Script%20Folder/README.md)
* [ Back to Top](#-calendar-days-date-table)
