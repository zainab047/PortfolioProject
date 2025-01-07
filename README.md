Hi Everyone!
Portfolio project contains all the projects i have worked on using SQL Server.
tidbits on my projects: 
1st - Portfolio-Project-Covid has more of an exploratory approach.
I've looked into covid data sourced from WHO until 2023-06-09; getting insights from the CovidDeaths and CovidVaccinations tables, focusing on:

-Data Retrieval: Filtering records where the continent is not null.
-Comparative Analysis: Examining total cases versus total deaths, calculating death percentages and infection rates.
-Country Rankings: Identifying countries with the highest infection and death rates.
-Continental Overview: Aggregating total deaths by continent.
-Global Statistics: Summarizing overall new cases, deaths, and death percentages.
-Vaccination Insights: Analyzing vaccination rates in relation to population, including running totals.
-CTEs and Temporary Tables: Organizing data for easier analysis and reuse.
-Creating Views: Establishing a view for streamlined access to vaccination data.

2nd - Data Cleaning Portfolio
This project aims to perform a series of data cleaning and transformation tasks on the Nashville Housing table sourced from Kaggle (tmthyjames).
Here’s a breakdown of the specific actions each part of the query is designed to accomplish:

-Standardize Date Format: The query alters the saledate column to ensure it has a consistent date format.
-Populate Missing Property Addresses: It checks for null entries in the PropertyAddress field and updates them using available data from other records with the same parcelid.
-Identify Duplicates: The queries identify duplicate entries based on parcelid, PropertyAddress, and other fields, ensuring that there are no duplicates in the UniqueID field.
-Split Address into Components: The queries split the PropertyAddress into separate columns for address and city, and similarly parse the OwnerAddress into distinct components (address, city, state).
-Update Field Values: The queries convert the values in the SoldAsVacant field from 'Y'/'N' to 'Yes'/'No' for better readability.
-Remove Duplicate Records: They identify and delete duplicate records based on multiple fields to ensure that only unique entries remain in the dataset.
-Drop Unused Columns: Finally, the queries drop columns that are no longer needed, such as owneraddress, taxdistrict, propertyaddress, and saledate, to streamline the dataset.

In summary, the queries are focused on cleaning, standardizing, and restructuring the Nashville Housing dataset to improve data quality and usability.




