# Project Backgroud
Apex Machinery, established in 2004, is a joint venture that sells hydraulic excavators and other machinery in Thailand.

For the past two years, Apex Machinery’s market share has dropped. This is the reason why this Lost Sales Analysis was created to find the real reasons for the decline and help management plan for a recovery.

This project thoroughly analyzes Sales Opportunity Data and Field Histories on salesforce system to uncover why deals are lost to identify patterns, competitor movements, and internal friction points. The goal is to transform loss into learning, giving management the data-driven insights needed to refine pricing strategies and sales tactics.


Insights and recommendations are provided on the following key areas:
* **Lost Sales Trends Analysis:** Evaluation of historical lost sales patterns at both the national and regional levels, focusing on customer types, competitors, and primary reasons for loss.
* **Competitor Advantage Mapping:** Identifies which rival brands outperform us in key categories. Users can drill down into specific sub-reasons like technician skills or spare parts quality through interactive tooltips, helping to pinpoint our exact weaknesses against each competitor.
* **Product Level Performance:** Analyzes loss rates by product and identifies the key factors that determine our wins and losses against competitors.
*  **Regional Comparisons:** Compares performance across territories to identify localized competitor threats and regional patterns, helping management adjust their strategy for each specific area.

An interactive Power BI dashboard can be found [here.](https://github.com/oat0054/oat0054.github.io/blob/main/projects/Sales%20Products%20Analysis.pdf)
* Power Query (M Language) scripts used for data cleaning and transformation can be found here.
* DAX Measures used to calculate business logic (e.g., % Loss Rate, Effective Forecast) can be found .
* Salesforce Data Mapping and object relationship details can be found .
* Data Validation steps performed in Power Query to ensure data accuracy can be found .


# Project 1: Sales Products Analysis 2019 

![](images/sale_product_analysis.png)
#### [Respond to the query using Python](https://github.com/oat0054/oat0054.github.io/blob/main/projects/Sales%20Products%20Analysis.pdf)
questions:
   - What was the best month for sales? How much was earned that month?
   - What City had the highest number of sales?
   - What time should we display adverstisement to maximize likelihood of  customer's buying product?
   - What products are most often sold together?
   - What product sold the most? Why do you think it sold the most?


key technique:
  - merge the 12 months of sales data into a single csv file
  - remove rows of missing values
  - remove text data rows that not related
  - change data type
  - add new columns
  - regular expression
  - aggregate
  - create chart with matplotlib.pyplot


# Project 2: Sales Management - Fulfilling the business request
![](images/business_request.png)
#### [Data Cleansing & Transformation (SQL)](projects/sales_sql_bi)
- extract data using SQL
- clean data
- transform necessary data
- join table

![](images/sql_sales.png)


#### [Creating a Data Model with Power BI](images/model_sales_powerbi.png)
- create a data model using the Star Schema
- connect FACT_Budget to FACT_InternetSales and other DIM tables

![](images/model_sales_powerbi.png)

#### [Sales Management Dashboard](https://app.powerbi.com/links/vu6NZIJEoY?ctid=4dd8a667-96b2-4697-8036-3b1a6c85424e&pbi_source=linkShare)
- create a dashboard using Power BI
- design a dashboard for displaying sales overview
- design a dashboard for displaying customer details
- design a dashboard for displaying product details

![](images/sales_dashboard.png)




# Project 3: 24 hours of le mans 2023: Web Scrapping

#### [Web Scrapping using Python](https://github.com/oat0054/oat0054.github.io/blob/main/projects/24%20hours%20of%20le%20mans%202023.pdf)
questions:
   - How many teams participated in the Le Mans 2023 event?
   - How many cars are there in each class?
   - What is the average number of laps for each class of car?
   - What are the top 3 cars for each class?
   - What is the performance comparison between the Chevrolet Corvette C8.R and the hypercar class?(based on the "labs" parameter)


task:
   - Scraping data using the Gazpacho library
   - Create a function to scrape team names
   - Create data frame
   - Create visualizations using matplotlib.pyplot

![](images/leman_lab.png)


