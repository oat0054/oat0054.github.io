# Opportunity Lost (Lost Deal Table)

### Business Objective
1. **Detailed Competitor Insights:** I extracted competitor brands, models, and pricing from multiple Salesforce fields into a single view to compare them directly against our offers.

2. **Accurate Loss Analysis:** By splitting multi-select "Loss Reasons," the dashboard can clearly show every reason why we lost a deal, helping management improve sales strategies.

3. **Value Estimation:** The script automatically calculates the estimated value of lost opportunities, allowing the team to prioritize and focus on high-impact issues.

### Key Technical Features
* **Smart Competitor Logic:** I used a "Record" technique to pick the "winning" competitor's data from several different columns in one efficient pass.

* **Handling Multi-Select Data:** I split multi-select Loss Reasons and joined them with a master list to ensure clean and standardized reporting.

* **Performance:** I filtered rows early and selected only necessary columns to save memory.

<details>
<summary><b>View M Language Script (Click to expand)</b></summary>
  
<img width="1337" height="2623" alt="fVYz1msmwu" src="https://github.com/user-attachments/assets/76523425-39c3-4d61-95a5-b9f3aac73582" />


</details>

---

###  Navigation
* [ Return to Project Overview](../README.md)
* [ Back to Main Power Query (M) Scripts](https://github.com/oat0054/oat0054.github.io/blob/main/Power%20Query%20(M)%20Script%20Folder/README.md)
* [ Back to Top](#-calendar-days-date-table)


