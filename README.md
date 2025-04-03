# UAE Used Cars Analysis (Interactive Dashboard creation using Power Bi)

## Table of Contents

- [Project Overview](#project-overview)

- [Data Sources](#data-source)

- [Recommendations](#recommendations)


### Project Overview

This data analysis project aims to provide insights into Used cars in United Arab Emirates (UAE) . By analyzing this data, I seek to identify the market trends and popularity of used cars based on thier mileage, price, age, location, and make data-driven recommendations for buyers. 


### Data Source
UAE Used cars Data: The primary dataset used for this analysis is the "uae_used_cars_10.csv" file, containing detailed information on used cars in UAE like the Make, Model, Year, Mileage, Price, Location and Sellers decription.
Dataset can be found in Kaggle [download](https://www.kaggle.com/datasets/mohamedsaad254/uae-used-cars-analysis-full-project-v1-0)

### Tools Used
SQL
- Data Cleaning
- Aggregation.
- The use of CASE Statment to group the yearly mileage into High or Low.
- Extracting of data in columns needed for the visualization.

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
  
- The dataset contain an empty, none and unkown data in the Cylinder column, which I grouped them as Others using the CASE Statement query below,

``` SQL
SELECT Cylinders, 
       CASE
         WHEN Cylinders LIKE 3 THEN 3
         WHEN Cylinders LIKE 4 THEN 4
         WHEN Cylinders LIKE 5 THEN 5
         WHEN Cylinders LIKE 6 THEN 6
         WHEN Cylinders LIKE 8 THEN 8
         WHEN Cylinders LIKE 10 THEN 10
         WHEN Cylinders LIKE 12 THEN 12
         ELSE 'Others'
        END AS Cylinder_Types 
FROM uae_used_cars_10k
GROUP BY Cylinders;
```

- Extracted the data columns need for my visualization by using this sql query;

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
	 CASE
         WHEN Cylinders LIKE 3 THEN 3
         WHEN Cylinders LIKE 4 THEN 4
         WHEN Cylinders LIKE 5 THEN 5
         WHEN Cylinders LIKE 6 THEN 6
         WHEN Cylinders LIKE 8 THEN 8
         WHEN Cylinders LIKE 10 THEN 10
         WHEN Cylinders LIKE 12 THEN 12
         ELSE 'Other'
        END AS Cylinder_Types, 
	 `Fuel Type`,
	 Transmission,
	 Color,
	 `Description`
  FROM uae_used_cars_10k
  GROUP BY State, make, Model, `Body Type`, Price, Mileage, `Year`, Cylinder_Types, `Fuel Type`, Transmission, Color, `Description`
  ORDER BY Price DESC;
  ```
  

### Exploratory Data Analysis
EDA involved exploring the data to answer key questions, such as:

- What is the total value of used cars in UAE?
- What is the total number of used cars in UAE?
- What is the average age of used cars in UAE
- What is the top 10 popular Brands?
- What is the top 7 expensive cars?
- What is the popular body type of cars?
- What is the average mileage of each brand?
- What is the popular color, fuel types and transmission of used cars in UAE? 


### Results/Findings
The Insight to this data are as follows;

- Total Value of Used Cars: AED 2.45Bn
- Total Number of Cars: 10,000
- Average Mileage: 27,821
- Average Age of used cars: 11



  

- What is the top 10 popular Brands;
  From the data the most popular brand in UAE is the Mercedes-Benz.
  
  Below is the SQL query used;

  ``` SQL
  SELECT 
		Make,
	      Count(Make) AS No_of_Used_Cars
  FROM uae_used_cars_10k
  GROUP BY Make
  ORDER BY COUNT(Make) DESC
  LIMIT 10;
  ```

  
  

![Top 10 Brands in UAE](https://github.com/user-attachments/assets/afa21a72-96dd-44f6-983a-eafee24d79f2)





- What is the top 7 expensive cars?
  From the data the most expensive brand is Maclaren and the models P1, Elva and Senna holds the top 5 with Mercedes-Benz slr and Ferrari 599 taking the 6th and 7th spot.

Below is the SQL query used;


``` SQL
SELECT 
    Make,
    Model,
    Year,
    SUM(Price) AS 'Value',
    Description
FROM uae_used_cars_10K
GROUP BY Make, Model, Year, `Description`
ORDER BY SUM(Price) DESC
LIMIT 7;
```
   
  
![Top 7 Expensive Cars In UAE](https://github.com/user-attachments/assets/78a5ec43-537f-40db-b9d1-189499782f18)



- What is the popular body type of cars?
  From the data, SUVs are the most preferred car body type in UAE with over 4,600 cars.

  Below is the SQL query used;

``` SQL
SELECT 
	`Body Type`,
    	COUNT(`Body Type`) AS No_of_Cars
FROM uae_used_cars_10k
GROUP BY `Body Type`
ORDER BY COUNT(`Body Type`) DESC;
``` 


![Popular Body types preferred in UAE](https://github.com/user-attachments/assets/21e51477-7cb9-4b1f-ba0c-d066eec98e10)


  
- What is the popular color, fuel types, cylinder and transmission of used cars in UAE?
  From the data, it is observed that the most preferred color, fuel type, cylinder and transmission are White, Gasoline, 6 Cylinder and Automatic transmission respectively.

   Below is the SQL query used;
  

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

