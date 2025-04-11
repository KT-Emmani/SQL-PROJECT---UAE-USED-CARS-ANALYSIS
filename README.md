# UAE Used Cars Analysis (Interactive Dashboard creation using Power Bi)

## Table of Contents

- [Project Overview](#project-overview)

- [Data Source](#data-source)
- [Data Preparation](#data-preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)  

- [Recommendations](#recommendations)


## Project Overview

This data analysis project aims to provide insights into Used cars in United Arab Emirates (UAE) . By analyzing this data, I seek to identify the market trends, popularity and what features of used cars matters most in determining the price based on thier mileage, age, location, fuel type, transmission, damage type and make data-driven recommendations for sellers and buyers. 


## Data Source
UAE Used cars Data: The primary dataset used for this analysis is the "uae_used_cars_10.csv" file, which contains 12 columns.
Dataset can be found in Kaggle [download](https://www.kaggle.com/datasets/mohamedsaad254/uae-used-cars-analysis-full-project-v1-0)

#### Sample Dataset

![Used cars dataset sample](https://github.com/user-attachments/assets/c38c47e4-bdec-4b11-8529-ab6e71aad463)



## Data Preparation

### Tools Used
- SQL for cleaning, manipulation, and extracting of data.
- Power Bi for visualization.

### Cleaning 
In the initial data preparation phase, I performed the following tasks:

- Created a project database in Mysql.
- Imported the csv file.
- I checked the data types of the columns;

  ``` sql
  DESCRIBE uae_used_cars_10k;
  ```
  
- The dataset contain an empty, none and unkown fields in the Cylinder column, which I grouped them all as UNKNOWN using the CASE Statement query below,

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
         ELSE 'Unknown'
        END AS Cylinder_Types 
FROM uae_used_cars_10k
GROUP BY Cylinders;
```
- I added new coloumns for average price, average mileage and average age for the unique model with the use of window function and grouped them into class with the use of a CASE Statement.

- I extracted unique substrings for accident type from the description column;

``` SQL
SELECT 
TRIM(REPLACE(RIGHT (`Description`, LENGTH(`description`) - POSITION(':' IN `Description`)), '.' , '')) AS Damaged_Type
FROM Uae_used_cars_10k
GROUP BY Damaged_Type;
```

- Extracted the data columns need for my visualization by using this sql query;

``` SQL
WITH Used_Cars AS
 (
 SELECT 
	 TRIM(Location) AS State,
	 Make,
	 Model,
	 `Body Type`,
	 Price,
     CASE	
		 WHEN Price <= 49999 THEN 'Less Than 50K'
         WHEN Price BETWEEN 49999 AND 120000 THEN '50K - 119K'
         WHEN PRICE BETWEEN 119999 AND 250000 THEN '120K - 249K'
         WHEN Price BETWEEN 249999 AND 500000 THEN '250K - 499K'
         WHEN Price BETWEEN 499999 AND 1000000 THEN '500K - 999K'
         ELSE '1M Or Above'
	  END AS Price_Range,
	 Mileage,
     CASE	
		 WHEN Mileage <= 74999 THEN 'Less Than 75K'
         WHEN Mileage BETWEEN 74999 AND 150000 THEN '75K - 149K'
         WHEN Mileage BETWEEN 149999 AND 225000 THEN '150K - 224k'
         ELSE '225k Or Above'
	  END AS Mileage_Range,
     COUNT(*) AS No_used_Cars,
	 `Year`,
	 YEAR(CURDATE()) - `year` AS Years_Used,
	 CASE -- To group the empty, none and unkown fields in the cylinder column to unkown--
         WHEN Cylinders LIKE 3 THEN 3
         WHEN Cylinders LIKE 4 THEN 4
         WHEN Cylinders LIKE 5 THEN 5
         WHEN Cylinders LIKE 6 THEN 6
         WHEN Cylinders LIKE 8 THEN 8
         WHEN Cylinders LIKE 10 THEN 10
         WHEN Cylinders LIKE 12 THEN 12
         ELSE 'Unkown' 
        END AS Cylinder_Types, 
	  -- To extract a substring from the Decription column (string) to know whether a used cars has an accident history or not --
	 TRIM(REPLACE(RIGHT (`Description`, LENGTH(`description`) - POSITION(':' IN `Description`)), '.' , '')) AS Type_of_Damaged,
	 `Fuel Type`,
	 Transmission,
     Color,
	 `Description`
  FROM uae_used_cars_10k
  GROUP BY State, make, Model, `Body Type`, Price, Price_Range, Mileage, Mileage_Range, `Year`, Cylinder_Types, `Fuel Type`, Type_of_Damaged, Transmission, Color, `Description`
  ORDER BY Price DESC
  )
  
  SELECT 
  State,
  Make,
  Model,
  `Body Type`,
  No_used_Cars,
  COUNT(No_used_cars) OVER (ORDER BY `Year`, No_used_cars) AS Cum_No_of_cars,
  Price,
  Price_Range,
  ROUND(AVG(Price) OVER (PARTITION BY Model, `Body Type`), 2)  AS Avg_Price,
  CASE 
		WHEN Price > ROUND(AVG(Price) OVER (PARTITION BY Model, `Body Type`), 2) THEN 'Above_AvgPrice'
        WHEN Price < ROUND(AVG(Price) OVER (PARTITION BY Model, `Body Type`), 2) THEN 'Below_AvgPrice'
        ELSE 'AvgPrice'
	END AS Avg_PricePos,
  Mileage,
  Mileage_Range,
  ROUND(AVG(Mileage) OVER (PARTITION BY Model, `Body Type`), 0) AS Avg_Mileage,
  CASE 
		WHEN Mileage > ROUND(AVG(Mileage) OVER (PARTITION BY Model, `Body Type`), 0) THEN 'Above_AvgMileage'
        WHEN Mileage < ROUND(AVG(Mileage) OVER (PARTITION BY Model, `Body Type`), 0) THEN 'Below_AvgMileage'
        ELSE 'Avg_Mileage'
	END AS Avg_MileagePos,
  `Year`,
  Years_Used,
  CASE	
		 WHEN Years_Used <= 4 THEN '0 - 4yrs'
         WHEN Years_Used BETWEEN 4 AND 11 THEN '5yrs - 10yrs'
         WHEN Years_Used BETWEEN 10 AND 15 THEN '11yrs - 15yrs'
         ELSE '16yrs -20yrs'
	  END AS Age_Range,
  ROUND(AVG(Years_Used) OVER (PARTITION BY Model, `Body Type`), 0) AS Avg_Years_of_car,
  CASE 
		WHEN Years_Used > ROUND(AVG(Years_Used) OVER (PARTITION BY Model, `Body Type`), 0) THEN 'Above_AvgAge'
        WHEN Years_Used < ROUND(AVG(Years_Used) OVER (PARTITION BY Model, `Body Type`), 0) THEN 'Below_AvgAge'
        ELSE 'Avg_Age'
	END AS Avg_AgePos,
  Cylinder_Types,
  `Fuel Type`,
  Transmission,
  Color,
  Type_of_Damaged,
  `Description`
  FROM Used_Cars;
```

### Final Dataset

![used cars dataset - worked  ](https://github.com/user-attachments/assets/cafcd53e-0082-4830-ab0b-1243b087e08f)



## Exploratory Data Analysis

### Dataset Overview 
The analysis is based on a dataset of 10,000 used cars in UAE. The dataset contains information on the make, model, year, price, mileage, body type, cylinder, transmissions, fuel type, color and descriptions to help understand the market trends and popularity of used cars in each state and UAE at large.

After analysing the data, the following observations were found;
- The data conatined used cars from 8 different states in UAE.
- There are 65 different brands (make) with 488 different models.
- Manufacturing year of models are from 2005 to 2024 with an average age of 11.
- Mileage ranges from 10,006 to 299,996 with an average of 155.16K.
- The expensive car is Mclaren P1 costing AED 14,686,975 and the cheapest car is Nissan Altima costing AED 7,183.
- Total Value of Used Cars: AED 2.45Bn
  
#### - Used cars per state
  

From the data, Dubai has the the most number of used cars with a total number of 8,011 (80.11%) and Fujeirah having the least with a total number of 9 (0.09%).


![Number of Cars by State](https://github.com/user-attachments/assets/a6b9da72-c2b0-4d8b-884b-2d476ae2a824)



#### - Top 10 popular Brands;

  
  From the data, the most popular brand is the Mercedes-Benz with a total number of 1,486 contributing 14.86% of used cars in UAE. 
  
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

  ![Top 10 Brands](https://github.com/user-attachments/assets/0b13fbc9-fadb-4fdb-90e6-1a7bd3e1ced9)


#### - Top 10 expensive cars;
 
From the data, the most expensive brand is Maclaren and the models P1, Elva and Senna holds the top 5 with Mercedes-Benz slr and Ferrari 599 taking the 6th to 10th spot.

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
LIMIT 10;
```
   
![Top 10 Expensive Cars](https://github.com/user-attachments/assets/50b62d17-acfc-4cd6-93b4-e58bcfd9e426)




#### - Popular body type of cars;
  
From the data, SUVs are the most preferred car body type in UAE with a total number of 4,607 used cars.

Below is the SQL query used;

``` SQL
SELECT 
	`Body Type`,
    	COUNT(`Body Type`) AS No_of_Cars
FROM uae_used_cars_10k
GROUP BY `Body Type`
ORDER BY COUNT(`Body Type`) DESC;
```


![Body Type](https://github.com/user-attachments/assets/31dce767-0bf8-4945-825c-80ba07f10755)


#### - Popular Fuel type; 

From the data, Gasoline is the preferred fuel type among car owners in UAE with a percentage rate of 97.14%. Next is diesel with 153 cars then electric with 110 cars and hydrid with 23 cars.

Below is the SQL query used;

``` SQL
SELECT 
	`Fuel Type`,
    	COUNT(`Fuel Type`) AS No_of_Cars
FROM uae_used_cars_10k
GROUP BY `Fuel Type`
ORDER BY COUNT(`Fuel Type`) DESC;
```


![Fuel Types](https://github.com/user-attachments/assets/c8d12820-7d37-4637-8f8c-a3d385943c78)


#### - Popular Transmission

From the data, 9,626 (96.26%) used cars are automatic transmission while only 374 (3.74%) used cars have manual transmission.

Below is the SQL query used;

``` SQL
SELECT 
	Transmission,
    	COUNT(transmission) AS No_of_Cars
FROM uae_used_cars_10k
GROUP BY Transmission
ORDER BY COUNT(transmission) DESC;
```

![Transmission type](https://github.com/user-attachments/assets/f535ba28-875b-4abf-bbbb-5f2d74b7ea43)



## Dashboard


![Dashboard](https://github.com/user-attachments/assets/c068be70-2446-4ee9-bfa1-570b4f84bb58)


![Insights](https://github.com/user-attachments/assets/f991a57a-c484-4544-9c56-86b5d01c93b1)



![Records](https://github.com/user-attachments/assets/eefa55c1-e399-4733-882c-1cabedb732a6)


  
### Recommendations
Based on the analysis, I recommend the following actions:


