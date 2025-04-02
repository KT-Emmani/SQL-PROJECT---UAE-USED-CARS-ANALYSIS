# UAE Used Cars Analysis (Interactive Dashboard creation using Power Bi)

## Table of Contents

- [Project Overview](#project-overview)

- [Data Sources](#data-source)

- [Recommendations](#recommendations)


### Project Overview

This data analysis project aims to provide insights into Used cars in United Arab Emirates (UAE) . By analyzing this data, I seek to identify the market trends and popularity of used cars based on thier mileage, price, age and location, and make data-driven recommendations. 


### Data Source
UAE Used cars Data: The primary dataset used for this analysis is the "uae_used_cars_10.csv" file, containing detailed information on used cars in UAE like the Make, Model, Year, Mileage, Price, Location and Sellers decription.
Dataset can be found in Kaggle [download](https://www.kaggle.com/datasets/mohamedsaad254/uae-used-cars-analysis-full-project-v1-0)

### Tools Used
SQL 
- Data Cleaning
- Aggregation.
- The use of CASE Statment to group the yearly mileage into High or Low.
- Extracting of columns needed for the visualization.

Power Bi
- Visualization

### Data Cleaning/Preparation
In the initial data preparation phase, I performed the following tasks:

- Created a project database in Mysql.
- Imported the csv file
- Data cleaning and formatting by ensuring the data is consisitent and clean with respect to data types and data format.

  ``` sql
  DESCRIBE uae_used_cars_10k;
  ```
  
- The dataset does not contain empty or null data.
- Extracted columns for my visualization by using this sql query;

  ``` sql
  SELECT 
  	 TRIM(Location) AS State,
  	 Make,
  	 Model,
  	 `Body Type`,
  	 Price,
  	 Mileage,
  	 Year,
  	 YEAR(CURDATE()) - `year` AS Years_Used,
  	 ROUND(Mileage / (YEAR(CURDATE()) - `year`), 0) AS Yearly_Mileage,
  	 CASE 
  	   WHEN ROUND(Mileage / (YEAR(CURDATE()) - `year`), 0)  < 12000 THEN 'LOW'
  	   ELSE 'HIGH'
  	   END AS Mileage_Status,
     COUNT(Make) AS No_of_Cars,
     Cylinders,
     `Fuel Type`,
     Transmission,
     Color,
     `Description`
  FROM uae_used_cars_10k
  GROUP BY State, make, Model, `Body Type`, Price, Mileage, `Year`, Cylinders, `Fuel Type`, Transmission, Color, `Description`
  ORDER BY Price DESC;
  ```
  

- Created a new sheet to use Pivot Tables for the analysis according to the questions asked.

### Exploratory Data Analysis
EDA involved exploring the sales data to answer key questions, such as:

- What is the overall sales trend?
- Which category of pizza are customers favorite?
- What are the peak sales periods?
- Plato's top selling pizza types?


### Results/Findings
The Insight to this data are as follows;

- Total Revenue: $ 817.8K
- Total Quantity Sold: 49.5K
- Total Orders: 21.35K
- Average Order Value: $ 38.31

- Fridays are the busiest day of the week with a total of 8,106 orders and a revenue generation of $ 136k.
  

![Data Model - Pizza Sales - Excel 1_24_2025 7_51_16 PM](https://github.com/user-attachments/assets/68b785d3-98ff-4a52-aa13-fec7ffb1566f)



- July was the busiest month with a total of 4,301 orders and a revenue generation of $ 72.5K.
  

![Data Model - Pizza Sales - Excel 1_24_2025 7_52_38 PM](https://github.com/user-attachments/assets/4c7daf5c-4413-4b3c-97d9-9e98d75c1d5b)



- Among the categories of pizza, most of Plato Pizza's customers preferred the Classic with 14,888 quantity sold and generating 27% of its revenue for the year.


![Data Model - Pizza Sales - Excel 1_24_2025 7_50_50 PM](https://github.com/user-attachments/assets/1237936e-8846-4829-9cc9-5d5fdc123d5e)


- 12pm - 1pm tends to be the busiest time of the day for ordering pizza by their customers.
  

![Data Model - Pizza Sales - Excel 1_24_2025 7_50_15 PM](https://github.com/user-attachments/assets/d7c5e58d-fc65-4f5b-8098-ee58536e43f6)


- Plato's Pizza Top 3 Pizza types are;
  
   The Thai Chicken Pizza
  
   The Barbecue Chicken Pizza
  
   The California Chicken Pizza



![Data Model - Pizza Sales - Excel 1_24_2025 7_49_41 PM](https://github.com/user-attachments/assets/a5672950-2fe1-4bc0-97a1-0b5f6c530286)


### Dashboard

![Data Model - Pizza Sales - Excel 1_24_2025 7_25_30 PM](https://github.com/user-attachments/assets/94fedf2e-ddb6-4773-a5ad-725f8b36cd5f)


  
### Recommendations
Based on the analysis, I recommend the following actions:

- To reduce operational cost, Plato's pizza should consider operating from 12pm to 11pm.
- Plato's Pizza should consider running promotions in the month of september and october to boost sales during that period.

