
DROP TABLE IF EXISTS rental_fact;
CREATE TABLE rental_fact
(
	rental_id integer,
	inventory_id integer,
	customer_id integer,
	store_id integer,
	rental_date timestamp without time zone,
	payment_amount numeric(5,2)
);



DROP TABLE IF EXISTS dim_inventory;
CREATE TABLE dim_inventory
(
	inventory_id integer,
	category_name character varying(25),
	title character varying(225)
);



DROP TABLE IF EXISTS dim_customer;
CREATE TABLE dim_customer
(
	customer_id integer,
	first_name character varying(45),
	last_name character varying(45),
	district character varying(20),
	city character varying(45)	
);