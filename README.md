

# Retail Sales Data Analysis Project

## Project Overview

This project aims to analyze Walmart sales data to uncover trends and insights that can inform business decisions. The analysis covers various aspects such as product performance, sales trends, and customer behavior. The goal is to provide actionable insights that can help optimize sales strategies and improve overall business performance.

## Dataset

### Dataset Information

- **Name**: Walmart Store Sales Forecasting
- **Source**: [Kaggle](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting/data?select=features.csv.zip)
- **Description**: The dataset contains historical sales data for 45 Walmart stores located in different regions. Each store contains several departments, and the dataset includes weekly sales data, as well as holiday indicators and other features.

### File Details

- **features.csv**: This file contains metadata about the store and the week, such as whether it was a holiday week.
- **sales.csv**: This is the primary file used in this analysis. It contains detailed information about sales transactions.

### Table Schema

```sql
CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(10) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    vat FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(10 , 2 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin FLOAT(11 , 9 ) NOT NULL,
    gross_income DECIMAL(10 , 2 ) NOT NULL,
    rating FLOAT(2 , 1 ) NOT NULL
);
```

## Getting Started

### Prerequisites

- SQL Database (MySQL, PostgreSQL, or any other preferred SQL-based system)
- SQL Client or Interface (e.g., MySQL Workbench, pgAdmin)
- I personally used MySQL Workbench to draft my queries. 

### Setup Instructions

1. **Download Dataset**: Download the dataset from [Kaggle](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting/data?select=features.csv.zip).
2. **Extract and Import Data**: Unzip the downloaded files and import `sales.csv` into your SQL database.
3. **Create the `sales` Table**: Use the provided schema to create the `sales` table in your SQL database.
4. **Load Data**: Load the data into the `sales` table using the appropriate SQL import command or tool.

## SQL Queries for Analysis
 FOR THE CODE, REFER TO SQL_queries.sql file. 
    ```

## Insights and Recommendations

### Key Findings

- **Top-Selling Products**: Identified product lines that drive the most sales in terms of quantity and revenue.
<img width="263" alt="Screenshot 2024-06-20 at 4 07 19 PM" src="https://github.com/sanamjummani/Retail_Sales_Analysis/assets/99756504/a26b08e7-89e7-42dc-b22c-45a2bd25567c">

- **Sales Trends**: Highlighted seasonal trends and peak sales times, providing insights for better inventory and staffing decisions.
  <img width="354" alt="image" src="https://github.com/sanamjummani/Retail_Sales_Analysis/assets/99756504/4d1a2302-6de4-427c-85b7-ee5af3eaad51">

- **Customer Behavior**: Revealed customer types that contribute the most to high-value purchases, assisting in targeted marketing.
  <img width="329" alt="image" src="https://github.com/sanamjummani/Retail_Sales_Analysis/assets/99756504/fd905372-476b-40fc-be12-8de6595d12c8">

- **Payment Method Impact**: Analyzed the effectiveness of different payment methods in driving sales.
<img width="348" alt="image" src="https://github.com/sanamjummani/Retail_Sales_Analysis/assets/99756504/131e5a90-12ca-4027-9261-b294a2dcb74f">

  
- **Gross Margin and Product Rating**: Explored the relationship between product margins and customer feedback, aiding in pricing and quality decisions.
  <img width="304" alt="image" src="https://github.com/sanamjummani/Retail_Sales_Analysis/assets/99756504/1a80c18e-1289-4382-a3de-18e37862628c">


### Recommendations

- **Optimize Inventory for Top-Selling Products**: Ensure high stock levels for top-selling product lines like Food and beverages and Fashion accessories to avoid stockouts and maximize sales.
- **Target Marketing Efforts**: Focus on high-value customer types with personalized promotions to boost repeat purchases and loyalty.
- **Adjust Staffing Based on Sales Trends**: Schedule more staff during peak hours and days like Satudays and Tuesday evenings to handle increased customer traffic efficiently.
- **Analyze Payment Preferences**: Promote the most popular payment methods i.e. cash to streamline transactions and enhance customer satisfaction.

## Conclusion

This analysis provides a comprehensive view of Walmart's sales data, uncovering key insights and trends that can help drive business growth. By leveraging these findings, Walmart can optimize its sales strategies, enhance customer experiences, and improve overall operational efficiency.

---

