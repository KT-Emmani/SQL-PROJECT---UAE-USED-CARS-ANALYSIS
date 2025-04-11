USE UAE_USED_CARS_PROJECT;

DESCRIBE uae_used_cars_10k;

ALTER TABLE uae_used_cars_10k
MODIFY COLUMN `Year` INT; 


SELECT *
FROM uae_used_cars_10K;


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
         ELSE 'Unknown' 
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
  COUNT(No_used_cars) OVER (ORDER BY Make, Model) AS Cum_No_of_cars,
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
  
  
  
  SELECT 
	  TRIM(Location) AS State,
	  `Body Type`,
	  COUNT(Make) AS No_of_Cars,
	  SUM(Price) AS Total_Value
  FROM 
   uae_used_cars_10k
  GROUP BY State, `Body Type`
  ORDER BY SUM(Price) DESC;
  
  
  SELECT 
	  Location,
	  Make,
      `Body Type`,
	  Count(Make) AS No_of_Cars
  FROM uae_used_cars_10k
  GROUP BY Location, make, `Body Type`
  ORDER BY Count(Make) DESC;
  
   SELECT 
	  TRIM(Location) AS State,
	  COUNT(Make) AS No_of_Cars,
	  SUM(Price) AS Total_Value
  FROM 
   uae_used_cars_10k
  GROUP BY State
  ORDER BY SUM(Price) DESC;
  
  
  -- QUESTIONS
  
  -- What is the top 10 popular Brands?
  SELECT 
	Make,
    Count(Make) AS No_of_Used_Cars
  FROM uae_used_cars_10k
  GROUP BY Make
  ORDER BY COUNT(Make) DESC
  LIMIT 10;
  
  -- What is the top 7 expensive cars?
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

-- What is the popular body type of cars?
SELECT 
	`Body Type`,
    COUNT(`Body Type`) AS No_of_Cars
FROM uae_used_cars_10k
GROUP BY `Body Type`
ORDER BY COUNT(`Body Type`) DESC;

-- What is the popular color, fuel types, cylinder and transmission of used cars in UAE?
SELECT
	Color,
	COUNT(Color) AS No_of_Cars
FROM uae_used_cars_10k
GROUP BY Color
ORDER BY COUNT(Color) DESC;

SELECT
	`Fuel Type`,
	COUNT(`Fuel Type`) AS No_of_Cars
FROM uae_used_cars_10k
GROUP BY `Fuel Type`
ORDER BY COUNT(`Fuel Type`) DESC;


SELECT
	Transmission,
	COUNT(Transmission) AS No_of_Cars
FROM uae_used_cars_10k
GROUP BY Transmission
ORDER BY COUNT(Transmission) desc;
