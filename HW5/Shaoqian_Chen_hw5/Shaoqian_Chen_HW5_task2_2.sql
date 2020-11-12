DELETE FROM rental_fact;
INSERT INTO rental_fact(
						rental_id,
						inventory_id,
						customer_id,
						store_id,
						rental_date,
						payment_amount)
	VALUES
(6057,	1340,	187,	6,	'2005-07-11 04:03:40',	3.99),
(3548,	4498,	16	,   10,	'2005-07-06 02:23:39',	0.99),
(3031,	1184,	491,	5,	'2005-06-20 11:52:49',	4.99),
(15162,	1756,	439,	4,	'2005-08-22 14:41:05',	4.99),
(12825,	4495,	328,	3,	'2005-08-19 01:23:58',	0.99),
(13061,	730	,	576,	9,	'2005-08-19 09:43:39',	4.99),
(4350,  2223,	299,	10,	'2005-07-07 19:02:41',	2.99),
(11800,	2284,	350,	7,	'2005-08-17 11:29:52',	0.99),
(6433,	1357,	101,	8,	'2005-07-12 00:12:02',	5.99),
(15818,	2620,	439,	1,	'2005-08-23 14:59:58',	1.99);



DELETE FROM dim_customer;
INSERT INTO dim_customer (customer_id,
						  first_name,
						  last_name,
						  district,
						  city)
	VALUES
(439,	'Alexander','Fennell','Lombardia','Bergamo'),
(328,	'Jeffrey','Spear','West Java','Ciparay'),
(576,	'Morris','Mccarter','Kaohsiung','Fengshan'),
(16	,	'Sandra','Martin','England','Southend-on-Sea'),
(101,	'Peggy','Myers','Asir','Abha'),
(439,	'Alexander','Fennell','Lombardia','Bergamo'),
(491,	'Rick','Mattox','al-Daqahliya','Mit Ghamr'),
(299,	'James','Gannon','Hiroshima','Hiroshima'),
(350,	'Juan','Fraley','Tuvassia','Teboksary'),
(187,	'Brittany','Riley','Sumy','Sumy');




DELETE FROM dim_inventory;
INSERT INTO dim_inventory(
						inventory_id,
						category_name,
						title)
	VALUES
(2620,	'Action','Midnight Westward'),
(4495,	'Travel','Wolves Desire'),
(1184,	'Sports','Durham Panky'),
(2223,	'New','Jekyll Frogmen'),
(2284,	'Horror','Karate Moon'),
(730,	'Comedy','Closer Bang'),
(4498,	'Action','Women Dorado'),
(1340,	'Documentary','Expendable Stallion'),
(1357,	'Travel','Factory Dragon'),
(1756,	'Games','Grinch Massage');