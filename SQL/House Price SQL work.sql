# SQL questions - regression


   # 4. Select all the data from table house_price_data to check if the data was imported correctly
   
SELECT * FROM housing_data.regression_data_clean;

    # 5. Use the alter table command to drop the column date from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.

ALTER TABLE housing_data.regression_data_clean DROP date;

    # 6. Use sql query to find how many rows of data you have.
    
SELECT count(id) from housing_data.regression_data_clean
'21597 rows'

    # 7. Now we will try to find the unique values in some of the categorical columns:
        #What are the unique values in the column bedrooms?
        
SELECT DISTINCT bedrooms from housing_data.regression_data_clean
        
        #What are the unique values in the column bathrooms?
        
SELECT DISTINCT bathrooms from housing_data.regression_data_clean

        #What are the unique values in the column floors?
        
SELECT DISTINCT floors from housing_data.regression_data_clean
        
        #What are the unique values in the column condition?
        
SELECT DISTINCT regression_data_clean.condition from housing_data.regression_data_clean     #'condition' seems to be an inbuilt command
        
        #What are the unique values in the column grade?
        
SELECT DISTINCT grade from housing_data.regression_data_clean

    # 8. Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
    
SELECT * FROM housing_data.regression_data_clean
order by price DESC
limit 10;    

    # 9. What is the average price of all the properties in your data?
    
SELECT Round(AVG(price),2) FROM housing_data.regression_data_clean;
'Avg Price: $ 540296.57'

    # 10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data
        #What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
        
SELECT  bedrooms, Round(AVG(price),2) as 'AVG Price' FROM housing_data.regression_data_clean
group by bedrooms
order by bedrooms ASC

        #What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the second column.
        
SELECT  bedrooms, AVG(sqft_living) as 'AVG sqft Living' FROM housing_data.regression_data_clean
group by bedrooms
order by bedrooms ASC
        
        #What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the name of the second column.
        
SELECT  waterfront, Round(AVG(price),2) as 'AVG Price' FROM housing_data.regression_data_clean
group by waterfront
order by waterfront ASC
        
        #Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
        
SELECT regression_data_clean.condition, AVG(grade) FROM housing_data.regression_data_clean
group by regression_data_clean.condition
order by regression_data_clean.condition asc

"from visual check there seems to be some correlation"

    # 11. One of the customers is only interested in the following houses:
        #Number of bedrooms either 3 or 4
        #Bathrooms more than 3
        #One Floor
        #No waterfront
        #Condition should be 3 at least
        #Grade should be 5 at least
        #Price less than 300000
	#For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?
    
Select * FROM housing_data.regression_data_clean
where bedrooms in (3,4)
AND bathrooms > '3' 
AND floors = 1
AND waterfront = 0
AND regression_data_clean.condition >= '3'
AND grade >= '5'
AND price < '300000'

'Returns 0 matches because lowest price with all other conditions = 345100 '

    # 12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.

Select * FROM housing_data.regression_data_clean
WHERE price > (Select AVG(price)*2 FROM housing_data.regression_data_clean)

    # 13. Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE VIEW houses_priced_at_more_than_double_AVG AS    
Select * FROM housing_data.regression_data_clean
WHERE price > (Select AVG(price)*2 FROM housing_data.regression_data_clean)

    # 14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?

#Full query for AVG price by bedroom   
SELECT bedrooms, Round(AVG(price),2) AS 'AVG Price' FROM housing_data.regression_data_clean
where bedrooms in (3,4)
group by bedrooms

#Split into 2 subqueries
(SELECT Round(AVG(price),2) AS 'AVG Price 3br' FROM housing_data.regression_data_clean
where bedrooms = '3') as br3

(SELECT Round(AVG(price),2) AS 'AVG Price 4br' FROM housing_data.regression_data_clean
where bedrooms = '4') as br4


# Throw it all together....
SELECT (
(SELECT Round(AVG(price),2) AS 'AVG Price 4br' FROM housing_data.regression_data_clean
where bedrooms = '4') -
(SELECT Round(AVG(price),2) AS 'AVG Price 3br' FROM housing_data.regression_data_clean
where bedrooms = '3') 
) AS 'AVG Price Diff 3BR v 4BR'
 FROM housing_data.regression_data_clean
 limit 1
 
 'Output of query matches manual calculation'
   
   # 15. What are the different locations where properties are available in your database? (distinct zip codes)

#Version 1    
SELECT DISTINCT zipcode FROM housing_data.regression_data_clean

#Version 2
SELECT zipcode, Count(id) as 'Amount Properties' FROM housing_data.regression_data_clean
group by zipcode

    # 16. Show the list of all the properties that were renovated.
    
SELECT * FROM housing_data.regression_data_clean
WHERE yr_renovated != '0'

    # 17. Provide the details of the property that is the 11th most expensive property in your database.

SELECT * FROM    
(SELECT * , RANK () OVER ( ORDER BY price DESC) price_rank FROM housing_data.regression_data_clean) sub1
WHERE price_rank = 11



#Project Scenario Objective : One of those parameters includes understanding which factors are responsible for higher property value - $650K and above.

#Query to see average values in houses above $650K:

Select Round(AVG(bedrooms),1), Round(AVG(bathrooms),1), Round(AVG(sqft_living),1), Round(AVG(sqft_lot),1), Round(AVG(floors),1), Round(AVG(grade),1), Round(AVG(sqft_above),1), Round(AVG(yr_built)) from
(Select * from housing_data.regression_data_clean
where price > 650000) sub1