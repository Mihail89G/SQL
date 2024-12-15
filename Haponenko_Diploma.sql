-----------------------------------------------------------------------------Create tables------------------------------------------------------------------------------------
--CREATE DATABASE Haponenko_Diploma;
--GO
--1.hr.employees
CREATE SCHEMA hr; 
DROP TABLE IF EXISTS hr.employees;
CREATE TABLE hr.employees
(empid            INT IDENTITY(1, 1) PRIMARY KEY  NOT NULL, 
lastname          NVARCHAR(100)                   NOT NULL,           
firstname         NVARCHAR(100)                   NOT NULL,
title             NVARCHAR(100)                   NOT NULL,
titleofcourtesy   NVARCHAR(100)                   NOT NULL,
birthdate         DATETIME                        NOT NULL CHECK (birthdate<=getdate()),
hiredate          DATETIME                        NOT NULL,
[address]         NVARCHAR(255)                   NOT NULL,
city              NVARCHAR(100)                   NOT NULL,
region            NVARCHAR(100)                       NULL,                                                                                                                                                                                    
postalcode        INT                             NOT NULL, 
country           NVARCHAR(100)                   NOT NULL,
phone             NVARCHAR(100)                   NOT NULL,
mgrid             INT FOREIGN KEY REFERENCES hr.[employees](empid),
modifieddate      DATETIME                            NULL
);

SELECT * FROM hr.employees;

--2.sales.customers
CREATE SCHEMA sales; 
DROP TABLE IF EXISTS sales.customers;
CREATE TABLE sales.customers
(custid           INT IDENTITY(1, 1) PRIMARY KEY  NOT NULL,      
companyname       NVARCHAR(100)                   NOT NULL,           
contactname       NVARCHAR(100)                   NOT NULL,
contacttitle      NVARCHAR(100)                   NOT NULL,
[address]         NVARCHAR(255)                   NOT NULL,
city              NVARCHAR(100)                   NOT NULL,
region            NVARCHAR(100)                       NULL,
postalcode        INT                             NOT NULL,
country           NVARCHAR(100)                   NOT NULL,                                                                                                                                                                                    
phone             NVARCHAR(100)                   NOT NULL,
fax               NVARCHAR(100)                       NULL
);

SELECT * FROM sales.customers;

--3.sales.shippers
CREATE SCHEMA sales; 
DROP TABLE IF EXISTS sales.shippers;
CREATE TABLE sales.shippers
(shipperid        INT PRIMARY KEY  NOT NULL,      
companyname       NVARCHAR(100)    NOT NULL,          
phone             NVARCHAR(100)    NOT NULL)

SELECT * FROM sales.shippers;

--4.sales.orders
CREATE SCHEMA sales; 
DROP TABLE IF EXISTS sales.[order];
CREATE TABLE sales.[order]
(orderid          INT IDENTITY(1, 1) PRIMARY KEY  NOT NULL,      
custid            INT FOREIGN KEY REFERENCES sales.[customers](custid),           
empid             INT FOREIGN KEY REFERENCES hr.[employees](empid),
orderdate         DATETIME                        NOT NULL,
requireddate      DATETIME                        NOT NULL,
shippeddate       DATETIME                        NOT NULL,
shipperid         INT FOREIGN KEY REFERENCES sales.[shippers](shipperid),
freight           NUMERIC(15,2) DEFAULT 0         NOT NULL,
shipname          NVARCHAR(100)                   NOT NULL,
shipaddress       NVARCHAR(255)                   NOT NULL,
shipcity          NVARCHAR(100)                   NOT NULL,
shipregion        NVARCHAR(100)                       NULL,
shippostalcode    INT                             NOT NULL,
shipcountry       NVARCHAR(100)                   NOT NULL
);

SELECT * FROM sales.[order];

--5.production.categories
CREATE SCHEMA production; 
DROP TABLE IF EXISTS production.categories;
CREATE TABLE production.categories
(categoryid         INT IDENTITY(1, 1) PRIMARY KEY  NOT NULL,  
categoryname        NVARCHAR(100)                   NOT NULL,
[description]       NVARCHAR(255)                   NOT NULL
);

SELECT * FROM production.categories;

--6.production.suppliers
CREATE SCHEMA production; 
DROP TABLE IF EXISTS production.suppliers;
CREATE TABLE production.suppliers
(supplierid         INT IDENTITY(1, 1) PRIMARY KEY  NOT NULL, 
companyname         NVARCHAR(100)                   NOT NULL,
contactname         NVARCHAR(100)                   NOT NULL,
contacttitle        NVARCHAR(100)                   NOT NULL,
[address]           NVARCHAR(255)                   NOT NULL,
city                NVARCHAR(100)                   NOT NULL,
region              NVARCHAR(100)                       NULL, 
postalcode          INT                             NOT NULL,
country             NVARCHAR(100)                   NOT NULL,  
phone               NVARCHAR(100)                   NOT NULL,
fax                 NVARCHAR(100)                       NULL
);

SELECT * FROM production.suppliers;

--7.production.products
CREATE SCHEMA production; 
DROP TABLE IF EXISTS production.products;
CREATE TABLE production.products
(productid         INT IDENTITY(1, 1) PRIMARY KEY  NOT NULL, 
productname        NVARCHAR(100)                   NOT NULL,
supplierid         INT FOREIGN KEY REFERENCES production.[suppliers](supplierid), 
categoryid         INT FOREIGN KEY REFERENCES production.[categories](categoryid),
unitprice          NUMERIC(15,2) DEFAULT 0         NOT NULL CHECK (unitprice>=0),
discontinued       BIT           DEFAULT 0         NOT NULL
);

SELECT * FROM production.products;

--8.sales.orderdetails;
CREATE SCHEMA sales; 
DROP TABLE IF EXISTS sales.orderdetails;
CREATE TABLE sales.orderdetails (
orderid      INT NOT NULL,
productid    INT NOT NULL,
unitprice    NUMERIC(15,2) DEFAULT 0 NOT NULL CHECK (unitprice >= 0),
qty          INT DEFAULT 1 NOT NULL CHECK (qty >= 0),
discount     NUMERIC(5,2) DEFAULT 0 NOT NULL CHECK (discount >= 0 AND discount <= 1),
PRIMARY KEY (orderid, productid),
FOREIGN KEY (orderid) REFERENCES sales.[order](orderid), 
FOREIGN KEY (productid) REFERENCES production.products(productid)
);

SELECT * FROM sales.orderdetails;

 -----------------------------------------------------------------------------------insert----------------------------------------------------------------------------------------      
--1.hr.employees
INSERT INTO hr.employees (lastname,firstname,title,titleofcourtesy,birthdate,hiredate,[address],city,region,postalcode,country,phone,mgrid,modifieddate)           
VALUES 
(N'Дэвис',        N'Сара',  N'CEO',                     N'мисс',    '08.12.1958 0:00:00','01.05.2002 0:00:00', N'7890 - 20th Ave. E.,Apt. 2A',        N'Сиэтл',     'WA',   10003,  N'США',             '(206) 555-0101',NULL, GETDATE()),
(N'Функ',	      N'Дон',   N'Vice President,Sales',	N'доктор',	'19.02.1962 0:00:00','14.08.2002 0:00:00', N'9012 W. Capital Way',	              N'Такома',    'WA',	10001,	N'США',	            '(206) 555-0100',1,GETDATE()),	
(N'Лью',	      N'Джуди', N'Sales Manager',	        N'мисс',	'30.08.1973 0:00:00','01.04.2002 0:00:00', N'2345 Moss Bay Blvd.',	              N'Киркланд',	'WA',	10007,	N'США',	            '(206) 555-0103',2,GETDATE()),	
(N'Пелед',        N'Иаиль', N'Sales Representative',	N'миссис',	'19.09.1947 0:00:00','03.05.2003 0:00:00', N'5678 Old Redmond Rd.',	              N'Редмонд',	'WA',	10009,	N'США',	            '(206) 555-0104',3,GETDATE()),	
(N'Бак',	      N'Свен',  N'Sales Manager',	        N'мистер',	'04.03.1965 0:00:00','17.10.2003 0:00:00', N'8901 Garrett Hill',	              N'Лондон',	NULL,	10004,	N'Великобритания',	'(71) 234-5678', 2,GETDATE()),	
(N'Суурс',        N'Пол',	N'Sales Representative',	N'мистер',	'02.07.1973 0:00:00','17.10.2003 0:00:00', N'3456 Coventry House, Miner Rd.',     N'Лондон',	NULL,	10005,	N'Великобритания',	'(71) 345-6789', 5,GETDATE()),	
(N'Кинг',	      N'Рассел',N'Sales Representative',	N'мистер',	'29.05.1970 0:00:00','02.01.2004 0:00:00', N'6789 Edgeham Hollow, Winchester Way',N'Лондон',	NULL,	10002,	N'Великобритания',	'(71) 123-4567', 5,GETDATE()),	
(N'Камерон',	  N'Мария', N'Sales Representative',	N'мисс',	'09.01.1968 0:00:00','05.03.2004 0:00:00', N'4567 - 11th Ave. N.E.',	          N'Сиэтл',	    'WA',	10006,	N'США',	            '(206) 555-0102',3,GETDATE()),	
(N'Долгопятова',  N'Зоя',   N'Sales Representative',	N'мисс',	'27.01.1976 0:00:00','15.11.2004 0:00:00', N'1234 Houndstooth Rd.',	              N'Лондон',	NULL,	10008,	N'Великобритания',	'(71) 456-7890', 5,GETDATE())	

SELECT * FROM hr.employees;

--2.sales.customers
INSERT INTO sales.customers (companyname,contactname,contacttitle,[address],city,region,postalcode,country,phone,fax)
VALUES 
(N'Клиент NRZBB',	N'Allen, Michael',	        N'Sales Representative',	N'Obere Str. 0123',	                N'Берлин',	   NULL, 10092,	N'Германия',	  '030-3456789',      '030-0123456'),
(N'Клиент MLTDN',	N'Hassall, Mark',	        N'Owner',	                N'Avda. de la Constitución 5678',	N'Мехико',	   NULL, 10077,	N'Мексика',	      '(5) 789-0123',	  '(5) 456-7890'),
(N'Клиент KBUDE',	N'Peoples, John',	        N'Owner',	                N'Mataderos  7890',	                N'Мехико',	   NULL, 10097,	N'Мексика',	      '(5) 123-4567',	    NULL),
(N'Клиент HFBZG',	N'Arndt, Torsten',	        N'Sales Representative',	N'7890 Hanover Sq.',	            N'Лондон',	   NULL, 10046,	N'Великобритания','(171) 456-7890',   '(171) 456-7891'),
(N'Клиент HGVLZ',	N'Higginbotham, Tom',	    N'Order Administrator',	    N'Berguvsvägen  5678',	            N'Лулео',	   NULL, 10112,	N'Швеция',	      '0921-67 89 01',    '0921-23 45 67'),
(N'Клиент XHXJV',	N'Poland, Carole',	        N'Sales Representative',	N'Forsterstr. 7890',	            N'Мангейм',	   NULL, 10117,	N'Германия',	  '0621-67890',	      '0621-12345'),
(N'Клиент QXVLA',	N'Bansal, Dushyant',	    N'Marketing Manager',	    N'2345, place Kléber',	            N'Страсбург',  NULL, 10089,	N'Франция',	      '(1) 456-7890',      NULL),
(N'Клиент QUHWH',	N'Ilyina, Julia',	        N'Owner',	                N'C/ Araquil, 0123',	            N'Мадрид',	   NULL, 10104,	N'Испания',	      '(91) 345 67 89',   '(91) 012 34 56'),
(N'Клиент RTXGC',	N'Raghav, Amritansh',	    N'Owner',	                N'6789, rue des Bouchers',	        N'Марсель',	   NULL, 10105,	N'Франция',	      '(171) 789-0123',    NULL),
(N'Клиент EEALV',	N'Bassols, Pilar Colome',	N'Accounting Manager',	    N'8901 Тсаввассен Blvd.',	        N'Тсаввассен', 'BC', 10111,	N'Канада',	      '(604) 901-2345',   '(604) 678-9012')

SELECT * FROM sales.customers;

--3.sales.shippers
INSERT INTO sales.shippers (shipperid,companyname,phone)
VALUES 
(1,N'Shipper GVSUA','(503) 555-0137'),
(2,N'Shipper ETYNR','(425) 555-0136'),
(3,N'Shipper ZHISN','(415) 555-0138')

SELECT * FROM sales.shippers;

--4.sales.orders
INSERT INTO sales.[order] (custid,empid,orderdate,requireddate,shippeddate,shipperid,freight,shipname,shipaddress,shipcity,shipregion,shippostalcode,shipcountry)
VALUES
(2,	5,	'04.07.2006 0:00:00',	'01.08.2006 0:00:00',	'16.07.2006  0:00:00',	3,	32.38,	N'Ship to 85-B',	    N'6789 rue de l`Abbaye',	                   N'Reims',	     NULL,	    10345,	N'Франция'),
(5,	6,	'05.07.2006 0:00:00',	'16.08.2006 0:00:00',	'10.07.2006  0:00:00',	1,	11.61,	N'Ship to 79-C',	    N'Luisenstr. 9012',	                           N'Münster',	     NULL,	    10328,	N'Германия'),
(6,	4,	'08.07.2006 0:00:00',	'05.08.2006 0:00:00',	'12.07.2006  0:00:00',	2,	65.83,	N'Destination SCQXA',	N'Rua do Paço, 7890',	                       N'Рио-де-Жанейро',N'RJ',	    10195,	N'Бразилия'),
(7,	3,	'08.07.2006 0:00:00',	'05.08.2006 0:00:00',	'15.07.2006  0:00:00',	1,	41.34,	N'Ship to 84-A',	    N'3456, rue du Commerce',	                   N'Lyon',	         NULL,	    10342,	N'Франция'),
(8,	4,	'09.07.2006 0:00:00',	'06.08.2006 0:00:00',	'11.07.2006  0:00:00',	2,	51.3,	N'Ship to 76-B',	    N'Boulevard Tirou, 9012',	                   N'Шарлеруа',	     NULL,	    10318,	N'Бельгия'),
(9,	3,	'10.07.2006 0:00:00',	'24.07.2006 0:00:00',	'16.07.2006  0:00:00',	2,	58.17,	N'Destination JPAIY',	N'Rua do Paço, 8901',	                       N'Рио-де-Жанейро',N'RJ',	    10196,	N'Бразилия'),
(10,5,	'11.07.2006 0:00:00',	'08.08.2006 0:00:00',	'23.07.2006  0:00:00',	2,	22.98,	N'Destination YUJRD',	N'Hauptstr. 1234',	                           N'Берн',	         NULL,	    10139,	N'Швейцария'),
(1,	9,	'12.07.2006 0:00:00',	'09.08.2006 0:00:00',	'15.07.2006  0:00:00',	3,	148.33,	N'Ship to 68-A',	    N'Starenweg 6789',	                           N'Женева',	     NULL,	    10294,	N'Швейцария'),
(3,	3,	'15.07.2006 0:00:00',	'12.08.2006 0:00:00',	'17.07.2006  0:00:00',	2,	13.97,	N'Ship to 88-B',	    N'Rua do Mercado, 5678',	                   N'Резенди',	     N'SP',	    10354,	N'Бразилия'),
(4,	4,	'16.07.2006 0:00:00',	'13.08.2006 0:00:00',	'22.07.2006  0:00:00',	3,	81.91,	N'Destination JYDLM',	N'Carrera1234 con Ave. Carlos Soublette #8-35',N'Сан-Кристобаль',N'Тачира',	10199,	N'Венесуэла')

SELECT * FROM sales.[order];


--5.production.categories
INSERT INTO  production.categories (categoryname,[description] )
VALUES
(N'Beverages',	    N'Soft drinks, coffees, teas, beers, and ales'),
(N'Condiments',	    N'Sweet and savory sauces, relishes, spreads, and seasonings'),
(N'Confections',	N'Desserts, candies, and sweet breads'),
(N'Dairy Products',	N'Cheeses'),
(N'Grains/Cereals',	N'Breads, crackers, pasta, and cereal'),
(N'Meat/Poultry',   N'Prepared meats'),
(N'Produce',	    N'Dried fruit and bean curd'),
(N'Seafood',	    N'Seaweed and fish')

SELECT * FROM production.categories;


--6.production.suppliers
INSERT INTO  production.suppliers (companyname,contactname,contacttitle,[address],city,region,postalcode,country,phone,fax)
VALUES
(N'Поставщик SWRXU',	N'Adolphi, Stephan',	N'Purchasing Manager',	    N'2345 Gilbert St.',	       N'Лондон',	NULL,	    10023,	N'Великобритания',	'(171) 456-7890',	NULL),
(N'Поставщик VHQZD',	N'Hance, Jim',	        N'Order Administrator',	    N'P.O. Box 5678	Новый',        N'Орлеан',	N'LA',	    10013,	N'США',	            '(100) 555-0111',	NULL),
(N'Поставщик STUAZ',	N'Parovszky, Alfons',	N'Sales Representative',	N'234 Oxford Rd.',	           N'Энн-Арбор',N'MI',	    10026,	N'США', 	        '(313) 555-0109',	'(313) 555-0112'),
(N'Поставщик QOVFD',	N'Balázs, Erzsébet',	N'Marketing Manager',	    N'7890 Sekimai MСШАshino-shi', N'Токио',	NULL,	    10011,	N'Япония',	        '(03) 6789-0123',	NULL),
(N'Поставщик EQPNC',	N'Holm, Michael',	    N'Export Administrator',	N'Calle del Rosal 4567',	   N'Овьедо',	N'Астурия',	10029,	N'Испания',	        '(98) 123 45 67',	NULL),
(N'Поставщик QWUSF',	N'Popkova, Darya',	    N'Marketing Representative',N'8901 Setsuko Chuo-ku',	   N'Осака',	NULL,	    10028,	N'Япония',	        '(06) 789-0123',	NULL),
(N'Поставщик GQRCV',	N'Ræbild, Jesper',	    N'Marketing Manager',	    N'5678 Rose St. Moonie Ponds', N'Мельбурн',	N'Виктория',10018,	N'Австралия',	    '(03) 123-4567',	'(03) 456-7890'),
(N'Поставщик BWGYE',	N'Iallo, Lucio',	    N'Sales Representative',	N'9012 King`s Way',	           N'Манчестер',NULL,	    10021,	N'Великобритания',	'(161) 567-8901',	NULL),
(N'Поставщик QQYEU',	N'Basalik, Evan',	    N'Sales Agent',	            N'Kaloadagatan 4567',	       N'Гетеборг',	NULL,	    10022,	N'Швеция',	        '031-345 67 89',	'031-678 90 12'),
(N'Поставщик UNAHG',	N'Barnett, Dave',	    N'Marketing Manager',	    N'Av. das Americanas 2345',	   N'Сан-Паулу',NULL,	    10034,	N'Бразилия',	    '(11) 345 6789',	NULL)

SELECT * FROM production.suppliers;

--7.production.products
INSERT INTO production.products (productname,supplierid,categoryid,unitprice,discontinued)
 VALUES
(N'Продукт HHYDP',	1,	1,	18,	   0),
(N'Продукт RECZE',	1,	1,	19,	   0),
(N'Продукт IMEHJ',	1,	2,	10,	   0),
(N'Продукт KSBRM',	2,	2,	22,	   0),
(N'Продукт EPEIM',	2,	2,	21.35, 1),
(N'Продукт VAIIV',	3,	2,	25,    0),
(N'Продукт HMLNI',	3,	7,	30,    0),
(N'Продукт WVJFP',	3,	2,	40,    0),
(N'Продукт AOZBW',	4,	6,	97,    1),
(N'Продукт YHXGE',	4,	8,	31,    0)

SELECT * FROM production.products;


--8.sales.orderdetails;
INSERT INTO sales.orderdetails (orderid,productid,unitprice,qty,discount)
VALUES
(1,	10,	14,	    12,	0),
(1,	1,	9.8,	10,	0),
(1,	2,	34.8,	5,	0),
(2,	3,	18.6,	9,	0),
(3,	4,	42.4,	40,	0),
(4,	5,	7.7,	10,	0),
(5,	5,	42.4,	35,	0.15),
(6,	7,	16.8,	15,	0.15),
(7,	8,	16.8,	6,	0.05),
(7,	9,	15.6,	15,	0.05)


SELECT * FROM sales.orderdetails;

--------------------------------------------VIEW------------------------------
DROP VIEW IF EXISTS vw_usa_employees_sales;
GO
CREATE VIEW vw_usa_employees_sales 
	AS
	SELECT e.empid,
		   e.lastname,
		   e.firstname,
		   count(distinct o.orderid) as number_orders,
		   sum((od.unitprice * od.qty) * (1 - od.Discount)) as tota_amount_sales,
		   sum(od.qty) as quantity_goods
		  FROM [hr].[employees] e
		  JOIN [sales].[order] as o on e.empid=o.empid
		  JOIN [sales].[orderdetails] as od on o.orderid=od.orderid
		 WHERE e.country='США'
		 GROUP BY e.empid,e.lastname,e.firstname;
GO

SELECT * FROM vw_usa_employees_sales;


DROP VIEW IF EXISTS vw_gb_employees_sales;
GO
CREATE VIEW vw_gb_employees_sales 
	AS
	SELECT e.empid,
		   e.lastname,
		   e.firstname,
		   count(distinct o.orderid) as number_orders,
		   sum((od.unitprice * od.qty) * (1 - od.Discount)) as tota_amount_sales,
		   sum(od.qty) as quantity_goods
		  FROM [hr].[employees] e
		  JOIN [sales].[order] as o on e.empid=o.empid
		  JOIN [sales].[orderdetails] as od on o.orderid=od.orderid
		 WHERE e.country='Великобритания'
		 GROUP BY e.empid,e.lastname,e.firstname;
GO

SELECT * FROM vw_gb_employees_sales;

------------------------------------------------trigger-----------------------------------------------------

DROP TRIGGER IF EXISTS check_count_employees;
GO
CREATE TRIGGER check_count_employees ON hr.employees
	INSTEAD OF INSERT 
	AS
	BEGIN
	DECLARE @CountEmployees INT;
		
        SELECT @CountEmployees = COUNT(*) 
        FROM hr.employees;

		IF @CountEmployees=10
    BEGIN

			RAISERROR('Hiring limit reached', 0, 0)
			ROLLBACK TRANSACTION;
    END
	ELSE
    BEGIN

        INSERT INTO hr.employees (lastname,firstname,title,titleofcourtesy,birthdate,hiredate,[address],city,region,postalcode,country,phone,mgrid,modifieddate)  
        SELECT lastname,firstname,title,titleofcourtesy,birthdate,hiredate,[address],city,region,postalcode,country,phone,mgrid,modifieddate  
        FROM inserted;
	END
	END;
GO


-------------------------------------------------------procedure-------------------------------------------------------
DROP PROCEDURE IF EXISTS create_update_new_employees;
GO
CREATE PROCEDURE create_update_new_employees

    @empid            INT = NULL,  
    @lastname         NVARCHAR(100),
    @firstname        NVARCHAR(100),
    @title            NVARCHAR(100),
    @titleofcourtesy  NVARCHAR(100), 
    @birthdate        DATETIME,
	@hiredate         DATETIME,
    @address          NVARCHAR(255),
    @city             NVARCHAR(100),
    @region           NVARCHAR(100),
    @postalcode       INT,
    @country          NVARCHAR(100),
    @phone            NVARCHAR(100),
    @mgrid            INT
AS
BEGIN
    BEGIN TRANSACTION;
    
    IF EXISTS (SELECT 1 FROM hr.employees WHERE empid = @empid)
    BEGIN
        UPDATE hr.employees
        SET lastname = @lastname,
            firstname = @firstname,
            title = @title,
            titleofcourtesy = @titleofcourtesy,
            birthdate = @birthdate,
			hiredate = @hiredate,
            [address] = @address,
            city = @city,
            region = @region,
            postalcode = @postalcode,
            country = @country,
            phone = @phone,
            mgrid = @mgrid,
            modifieddate = GETDATE()
        WHERE empid = @empid;
        
        RAISERROR('Employee record updated successfully', 0, 0) WITH NOWAIT;
    END
    ELSE
    BEGIN
        INSERT INTO hr.employees (lastname, firstname, title, titleofcourtesy, birthdate, hiredate, [address], city, region, postalcode, country, phone, mgrid, modifieddate)
        VALUES (@lastname, @firstname, @title, @titleofcourtesy, @birthdate, @hiredate, @address, @city, @region, @postalcode, @country, @phone, @mgrid, GETDATE());
        
        RAISERROR('New employee record created successfully', 0, 0) WITH NOWAIT;
    END;
    
    COMMIT TRANSACTION;
END;

--add new record
--EXEC create_update_new_employees 
--    @empid = NULL,  
--    @lastname = 'Джон',
--    @firstname = 'Купер',
--    @title = 'Manager',
--    @titleofcourtesy = 'мистер',
--    @birthdate = '1990-01-01',
--	@hiredate = '1990-01-01',
--    @address = '4567 - 11th Ave. N.E.',
--    @city = 'Los-Angeles',
--    @region = 'WA',
--    @postalcode = 101000,
--    @country = 'США',
--    @phone = '(123) 456-78-90',
--    @mgrid = 1; 

----change record
--EXEC create_update_new_employees 
--    @empid = 22,  
--    @lastname = 'BILL',
--    @firstname = 'Junior',
--    @title = 'CEO',
--    @titleofcourtesy = 'доктор',
--    @birthdate = '2000-01-01',
--	@hiredate = '2024-01-01',
--    @address = '7890 - 20th Ave. E.,Apt. 2A',
--    @city = 'NEW-York',
--    @region = null,
--    @postalcode = 102000,
--    @country = 'США',
--    @phone = '(123) 451-78-91',
--    @mgrid = 2; 

--SELECT * FROM [hr].[employees]

--Delete from [hr].[employees]
--Where empid>9
