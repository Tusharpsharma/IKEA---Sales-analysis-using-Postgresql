# IKEA- Sales-analysis
![Project Image Placeholder](https://github.com/Tusharpsharma/IKEA---Sales-analysis-using-Postgresql/blob/main/Ikea-logo.png)


## ERD
![Project Image Placeholder](https://github.com/Tusharpsharma/IKEA---Sales-analysis-using-Postgresql/blob/main/ERD%20Diagram.png)


### IKEA is a well-known global retailer that specializes in home furnishing products and solutions. Founded in Sweden in 1943 by Ingvar Kamprad, IKEA has grown to have a significant presence worldwide1. Here are some key points about IKEA:

**Product Range**: IKEA offers a wide variety of products, including furniture, kitchen appliances, bedding, lighting, and home accessories. They are known for their modern designs and affordable prices1.

**Store Experience:** Shopping at IKEA is unique because it involves navigating through a large showroom with room setups that allow customers to see how products look in a home environment. They also have in-store cafes and restaurants1.

**Sustainability:** IKEA is committed to sustainability and aims to become climate positive by 2030. They focus on using renewable and recycled materials in their products and reducing their carbon footprint2.

**Global Presence:** IKEA has stores in many countries around the world, including India, where they have locations in cities like Bengaluru, Hyderabad, and Mumbai.

**Innovative Solutions:** IKEA is known for its innovative solutions, such as the GERSBY bookcase hack that turns the gap between a fridge and the wall into functional storage space.


## Table of Contents
- [Introduction](#introduction)
- [Project Structure](#ERD)
- [Database Schema](#database-schema)
- [Business Problems](#business-problems)
- [SQL Queries & Analysis](#sql-queries--analysis)
- [Getting Started](#getting-started)
- [Questions & Feedback](#questions--feedback)
- [Contact Me](#contact-me)

## Project Structure

1. **SQL Scripts**: Code to create the database schema and queries for analysis.
2. **Dataset**: Real-time data on gym visits, membership, and member demographics.
3. **Analysis**: SQL queries solving practical business problems, each one crafted to address specific questions.

''' sql
### IKEA Project SCHEMA

### Product Table
CREATE TABLE products
(
	product_id VARCHAR(10) PRIMARY KEY,	
	product_name VARCHAR(35) ,
	category	VARCHAR(20),
	subcategory	VARCHAR(20),
	unit_pice FLOAT
);

### Stores Table

CREATE TABLE stores
(
	store_id	VARCHAR(10) PRIMARY KEY,
	store_name	VARCHAR(25),
	city	VARCHAR(25),
	country VARCHAR(25)
);

### Sales Table

CREATE TABLE sales
(
	order_id 	VARCHAR(10) PRIMARY KEY,
	order_date	DATE,
	product_id	VARCHAR(10) REFERENCES products(product_id), --FK
	qty	INT,
	discount_percentage	FLOAT,
	unit_price FLOAT,	
	store_id VARCHAR(10) REFERENCES stores(store_id) --FK
);


### Inventory Table
CREATE TABLE inventory
(
	inventory_id SERIAL PRIMARY KEY,
	product_id	VARCHAR(10) REFERENCES products(product_id), --FK
	current_stock 	INT,
	reorder_level INT
);
''' sql


