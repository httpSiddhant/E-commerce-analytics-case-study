# E-Commerce Sales & Business Analytics

## Project Overview

This project is an e-commerce analytics case study focused on understanding sales performance, customer behavior, product performance, profitability, and order trends.

The project follows the complete analytics workflow:

Data → Cleaning → SQL Analysis → Visualization → Insights → Recommendations

MySQL was used for data cleaning, data preparation and business analysis. Power BI was used to create an interactive dashboard.

## Business Problem

The business needs to understand its overall performance and identify the factors contributing to revenue and profit.

The analysis focuses on:

- Overall revenue and profit performance
- Monthly sales trends
- Product and category performance
- Customer revenue contribution
- Geographic performance
- Acquisition channel performance
- Payment methods
- Order status
- Discount activity

## Objectives

- Clean and prepare the e-commerce data
- Combine related datasets using SQL
- Calculate important business KPIs
- Analyze sales, customers and products
- Identify important business trends
- Create an interactive Power BI dashboard
- Generate data-driven business insights
- Provide business recommendations based on the analysis

## Dataset

The project uses four related datasets:

- Customers
- Orders
- Order Items
- Products

### Dataset Details

| Dataset | Records | Purpose |
|---|---:|---|
| Customers | 3,600 | Customer information, state and acquisition channel |
| Orders | 9,245 | Order dates, status, payment and shipping information |
| Order Items | 15,608 | Products purchased, quantity, price and discount |
| Products | 90 | Product details, category, price and cost |

### Relationships

The datasets were connected using the following relationships:

- customers.customer_id → orders.customer_id
- orders.order_id → order_items.order_id
- products.product_id → order_items.product_id

## Data Cleaning and Preparation

Data preparation was performed using MySQL.

The main cleaning steps included:

- Checking duplicate records
- Removing 38 duplicate order records
- Handling blank discount codes as "No Discount"
- Standardizing product categories
- Handling 199 missing unit-price values using the corresponding product list price
- Creating cleaned SQL views
- Combining customer, order, order item and product data
- Performing relationship and data-quality checks

A combined `sales_detail` view was created for the main business analysis.

## SQL Analysis

SQL was used to perform the main business analysis.

The analysis included:

- Overall revenue and profit
- Total orders and quantity
- Average Order Value
- Profit Margin
- Monthly revenue
- Revenue by category
- Revenue by state
- Top products
- Top customers
- Acquisition channel performance
- Payment method analysis
- Order status analysis
- Discount analysis
- Category profitability

### Main Calculations

Gross Sales:

Quantity × Unit Price

Net Sales:

Gross Sales − Discount Amount

Profit:

Net Sales − (Quantity × Unit Cost)

Average Order Value:

Total Revenue ÷ Total Orders

Profit Margin:

Total Profit ÷ Total Revenue

## Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Revenue | $1.86M |
| Total Orders | 8K |
| Total Quantity | 18K |
| Total Profit | $914.16K |
| Profit Margin | 49.20% |
| Total Customers | 2K |
| Average Order Value | $221.28 |
| Revenue per Customer | $908.17 |
| Total Discount | $44.57K |

## Power BI Dashboard

The Power BI dashboard contains two pages.

### Page 1: E-Commerce Sales Overview

The dashboard includes:

- Total Revenue
- Total Orders
- Total Quantity
- Total Profit
- Profit Margin
- Monthly Revenue
- Revenue by Category
- Revenue by State
- Top 10 Products by Revenue
- Year/Month filter
- Category filter
- State filter

### Page 2: Customer & Business Insights

The dashboard includes:

- Total Customers
- Average Order Value
- Revenue per Customer
- Total Discount
- Revenue by Acquisition Channel
- Orders by Payment Method
- Order Status Distribution
- Top 10 Customers by Revenue
- Profit by Category
- Payment Method filter
- Category filter
- Acquisition Channel filter

## Key Business Insights

1. The business generated approximately $1.86M in revenue and $914.16K in profit, resulting in a 49.20% profit margin.

2. November recorded the highest monthly revenue at approximately $230K, showing a strong late-year sales peak.

3. Furniture was the highest-revenue category at approximately $320K, followed by Kitchen and Decor.

4. California generated the highest state-level revenue at approximately $250K, followed by New York and Texas.

5. Organic Search was the highest-revenue acquisition channel, generating approximately $760K.

6. Cotton Patio Chair was the top product by revenue, generating approximately $68K.

7. Customer 3531 was the highest-revenue customer, contributing approximately $18.5K.

8. Furniture also produced the highest displayed category profit at approximately $147.12K.

## Business Recommendations

### 1. Strengthen High-Performing Acquisition Channels

Organic Search generates the highest revenue among the displayed acquisition channels. The business can continue improving its organic search presence and monitor its contribution over time.

### 2. Prepare for the November Sales Peak

November shows the highest monthly revenue. Inventory, marketing and operational planning should be prepared ahead of this period to support higher demand.

### 3. Prioritize High-Performing Categories and Products

Furniture has the highest revenue and category profit, while Cotton Patio Chair is the leading product by revenue. These high-performing products can receive focused inventory and promotional planning.

## Tools Used

- MySQL
- MySQL Workbench
- SQL
- Power BI
- Microsoft Word

## Project Structure

```text
ecommerce-analytics-case-study/
│
├── SQL/
│   └── ecommerce sales analysis.sql
│
├── Power_BI/
│   └── Ecommerce Analytics.pbix
│
├── Screenshots/
│   ├── E-Commerce Sales Overview.png
│   └── Customer & Business Insights.png
│
├── Report/
│   └── Ecommerce Analytics Business Report.docx
│
└── README.md
