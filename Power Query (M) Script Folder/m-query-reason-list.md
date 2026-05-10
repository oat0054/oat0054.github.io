# Reason Mapping

### Business Objective
In Salesforce, "Loss Reasons" are often captured as raw text or multi-select picklists. To create a meaningful **Lost Deals Analysis Dashboard**, these reasons must be:
1.  **Standardized:** Categorized into High-level "Main Reasons" (e.g., Pricing, Product).
2.  **Ordered Logically:** Sorted by the sales stage journey rather than alphabetically.

### Key Technical Features
*   **No Extra Files Needed (Self-Contained):** The mapping data is built directly into the script. This ensures the Power BI report works perfectly without needing a separate Excel file.
*   **Better Sorting Method:** I used List.PositionOf to rank the categories. This method is much faster and easier to update than using many if-else lines.
*   **Faster Loading:** I used Table.Buffer() to store the data in memory. This significantly speeds up the process when merging this table with other data.

<details>
<summary><b>View M Language Script (Click to expand)</b></summary>

<img width="1120" height="423" alt="Reason List" src="https://github.com/user-attachments/assets/5a367c82-eaea-4456-88de-9af1023a3cc7" />

</details>

<img width="1095" height="871" alt="image" src="https://github.com/user-attachments/assets/d95642fc-6bc4-4137-b315-3cd95f22de5a" />


---

###  Navigation
* [ Return to Project Overview](../README.md)
* [ Back to Main Power Query (M) Scripts](https://github.com/oat0054/oat0054.github.io/blob/main/Power%20Query%20(M)%20Script%20Folder/README.md)
* [ Back to Top](#-calendar-days-date-table)
