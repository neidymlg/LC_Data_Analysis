/* Basics Practice
https://www.youtube.com/watch?v=l8DCPaHc5TQ
https://www.geeksforgeeks.org/sql-for-data-analysis/

changed Order Date from text to date:
ALTER TABLE "AmazonSalesData" ALTER COLUMN "Order Date" TYPE DATE USING "Order Date"::date
*/
SELECT * FROM "AmazonSalesData" ORDER BY "Order Id" ASC;

SELECT * FROM "AmazonSalesData" WHERE ("Region", "Country", "Item Type", "Sales Channel", "Order Priority", 
	"Order Date", "Ship Date", "Units Sold", "Unit Price", "Unit Cost", "Total Revenue", "Total Cost", "Total Profit") IS NULL;

SELECT "Total Revenue" - "Total Cost" as "TP COPY", "Total Profit" From "AmazonSalesData";
SELECT "Order Priority" FROM "AmazonSalesData" WHERE "Order Priority" <> 'C';
SELECT "Order Priority" FROM "AmazonSalesData" WHERE "Order Priority" NOT IN ('L','C');
SELECT "Sales Channel", "Total Profit" FROM "AmazonSalesData" WHERE "Sales Channel" = 'Online' ORDER BY "Total Profit";
SELECT "Total Profit" FROM "AmazonSalesData" WHERE "Total Profit" > 1000000 ORDER BY "Total Profit" DESC;
SELECT "Total Profit" FROM "AmazonSalesData" WHERE "Total Profit" BETWEEN 0 and 10000 ORDER BY "Total Profit";
SELECT "Units Sold", "Region" FROM "AmazonSalesData" WHERE "Units Sold" > 1000 AND "Region" = 'Europe';
SELECT "Order Date" FROM "AmazonSalesData" WHERE "Order Date" >= '2/1/2013';
SELECT "Order Date" FROM "AmazonSalesData" WHERE date_part('year',"Order Date") = 2015 OR date_part('month',"Order Date") = 1 OR 
	date_part('day',"Order Date") = 1;
SELECT *, date_part('dow',"Order Date") AS "weekday" FROM "AmazonSalesData" WHERE date_part('dow',"Order Date") = '4';
SELECT "Order Priority" FROM "AmazonSalesData" WHERE "Order Priority" in ('C','L');
SELECT "Region" FROM "AmazonSalesData" WHERE "Region" Like 'A%';
SELECT "Region" FROM "AmazonSalesData" WHERE "Region" Like '%America%';

SELECT DISTINCT "Item Type" FROM "AmazonSalesData";

SELECT "Item Type", 
	CASE WHEN "Item Type" IN ('Personal Care', 'Cosmetics') THEN 'Beauty Products'
	WHEN "Item Type" IN ('Fruits', 'Beverages', 'Meat', 'Cereal', 'Snacks', 'Vegetables', 'Snacks', 'Baby Food') then 'Groceries'  
	ELSE "Item Type"
	END AS "Item Categories"
FROM "AmazonSalesData";

--a  table used with Amazon_Sales_Data for joining purposes, not real data
CREATE TEMPORARY TABLE IF NOT EXISTS Amazon_Example_People(
	id SERIAL PRIMARY KEY,
	order_id numeric
);

/*
practice add/drop columns, deleting rows:
	DELETE FROM Amazon_Example_People

*/
ALTER TABLE Amazon_Example_People ADD COLUMN temp_col char;
	
SELECT * FROM Amazon_Example_People;
	
SELECT count(*) FROM "AmazonSalesData";
	
INSERT INTO Amazon_Example_People (order_id) SELECT "Order Id" FROM "AmazonSalesData";
ALTER TABLE Amazon_Example_People DROP COLUMN temp_col;

SELECT asd."Region", asd."Order Id", aep.id, aep.order_id FROM "AmazonSalesData" AS asd 
JOIN Amazon_Example_People AS aep on asd."Order Id" = aep.order_id;

ALTER TABLE Amazon_Example_People ADD COLUMN order_date date;

CREATE TEMPORARY TABLE IF NOT EXISTS TEMP_COL(
	id SERIAL PRIMARY KEY,
	temp_date date
);

INSERT INTO TEMP_COL (temp_date) SELECT generate_series('2011-01-04','2011-04-13','1 day'::interval);
SELECT * FROM TEMP_COL;
INSERT INTO Amazon_Example_People (order_id) SELECT "Order Id" FROM "AmazonSalesData";
UPDATE Amazon_Example_People SET order_date = temp_date FROM TEMP_COL WHERE Amazon_Example_People.id =TEMP_COL.id;
SELECT * FROM Amazon_Example_People;

--join examples:
SELECT asd."Order Date", aep.order_date FROM "AmazonSalesData" AS asd 
LEFT JOIN Amazon_Example_People AS aep on asd."Order Date" = aep.order_date;

SELECT asd."Order Date", aep.order_date FROM "AmazonSalesData" AS asd 
RIGHT JOIN Amazon_Example_People AS aep on asd."Order Date" = aep.order_date;

SELECT asd."Order Date", aep.order_date FROM "AmazonSalesData" AS asd 
FULL JOIN Amazon_Example_People AS aep on asd."Order Date" = aep.order_date;

SELECT asd."Order Date", aep.order_date FROM "AmazonSalesData" AS asd 
JOIN Amazon_Example_People AS aep on asd."Order Date" = aep.order_date;

SELECT * FROM "AmazonSalesData" AS asd 
CROSS JOIN Amazon_Example_People AS aep;
--subquery example:
SELECT * FROM Amazon_Example_People AS aep WHERE order_date IN (SELECT "Order Date" FROM "AmazonSalesData");

--CTE with statement
WITH AverageTable (averageProfit) AS (
	SELECT AVG("Total Profit") 
	FROM "AmazonSalesData"
)
	SELECT * FROM "AmazonSalesData", AverageTable WHERE "Total Profit" > averageProfit;
	
--join multiple tables
SELECT asd."Order Date", aep.order_date, aep.id, tp.id FROM "AmazonSalesData" AS asd 
JOIN Amazon_Example_People AS aep on asd."Order Date" = aep.order_date
JOIN TEMP_COL AS tp on aep.id = tp.id;


SELECT asd."Total Revenue", asd."Sales Channel", aep.id, asd."Region", asd."Order Id", aep.id, aep.order_id FROM "AmazonSalesData" AS asd 
JOIN Amazon_Example_People AS aep on asd."Order Id" = aep.order_id
WHERE asd."Total Revenue" > 500000 AND asd."Sales Channel" = 'Offline' AND aep.id > 50 
ORDER BY asd."Total Revenue";


--group by/aggregation examples:
SELECT "Sales Channel", SUM("Total Revenue"), avg("Total Revenue"),  COUNT("Sales Channel") FROM "AmazonSalesData" GROUP BY "Sales Channel";
SELECT "Item Type", SUM("Total Revenue"), avg("Total Revenue"),  COUNT("Sales Channel") FROM "AmazonSalesData" GROUP BY "Item Type" ORDER BY SUM("Total Revenue") DESC LIMIT 5
SELECT "Item Type", avg("Total Profit") FROM "AmazonSalesData" GROUP BY "Item Type";
SELECT "Region", SUM("Total Profit") FROM "AmazonSalesData" GROUP BY "Region";
SELECT DISTINCT "Region", "Country", AVG("Total Profit") OVER (PARTITION BY "Region" ORDER BY "Country") FROM "AmazonSalesData" ORDER BY "Region", "Country";
SELECT DISTINCT "Region", "Order Priority", AVG("Total Profit") OVER (PARTITION BY "Region" ORDER BY "Order Priority") 
	FROM "AmazonSalesData" ORDER BY "Region", "Order Priority";

SELECT aep.order_date, COUNT(aep.order_date)  FROM "AmazonSalesData" AS asd 
JOIN Amazon_Example_People AS aep on asd."Order Date" = aep.order_date GROUP BY aep.order_date;

SELECT tp.id, aep.order_date, COUNT(aep.order_date), COUNT(tp.id) FROM "AmazonSalesData" AS asd 
JOIN Amazon_Example_People AS aep on asd."Order Date" = aep.order_date
JOIN TEMP_COL AS tp on aep.id = tp.id 
GROUP BY tp.id, aep.order_date
ORDER BY tp.id, aep.order_date;


--subquery practice
SELECT "Total Profit" FROM "AmazonSalesData" WHERE "Total Profit" > (SELECT AVG("Total Profit") FROM "AmazonSalesData");

--View
CREATE OR REPLACE VIEW AmazonFullView AS SELECT "Item Type", "Total Profit" FROM "AmazonSalesData"
SELECT * FROM AmazonFullView;

--Rank
SELECT "Region", "Order Priority", 
	RANK() OVER (ORDER BY "Order Priority"),
	DENSE_RANK() OVER (ORDER BY "Order Priority"),
	ROW_NUMBER() OVER (ORDER BY "Order Priority") FROM "AmazonSalesData";

SELECT "Region", "Order Priority", ROW_NUMBER() OVER (PARTITION BY "Region" ORDER BY "Order Priority") FROM "AmazonSalesData"

--Union
SELECT temp_date FROM temp_col
UNION ALL
SELECT "Order Date" FROM "AmazonSalesData" ORDER BY temp_date;