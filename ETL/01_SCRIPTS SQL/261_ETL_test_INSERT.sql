-- -------------------- --
-- CALENDAR_YEAR_LOOKUP --
-- -------------------- --

INSERT INTO CALENDAR_YEAR_LOOKUP
	(WEEK_KEY,WEEK_IN_YEAR,YEAR,FISCAL_PERIOD,YEAR_WEEK,QUARTER,MONTH_NAME,MONTH,HOLIDAY_FLAG)
VALUES
	(263,1,2018,'FY18','2018/1',1,'January',1,'y');

INSERT INTO CALENDAR_YEAR_LOOKUP
	(WEEK_KEY,WEEK_IN_YEAR,YEAR,FISCAL_PERIOD,YEAR_WEEK,QUARTER,MONTH_NAME,MONTH,HOLIDAY_FLAG)
VALUES
	(264,2,2018,'FY18','2018/2',1,'January',1,'n');
	


commit;

-- -------------------- --
-- OULTET_LOOKUP 		--
-- -------------------- --

INSERT INTO OUTLET_LOOKUP
    (SHOP_NAME,ADDRESS_1,MANAGER,DATE_OPEN,OPEN,OWNED_OUTRIGHT,FLOOR_SPACE,ZIP_CODE,CITY,STATE,SHOP_CODE)
VALUES
	('e-Fashion Paris','450 Champs Elys�es','Ismail',TO_DATE('02/01/18', 'dd/mm/yy'),'Y','Y',3000,75000,'Paris','Ile de France',353);
	
INSERT INTO OUTLET_LOOKUP
    (SHOP_NAME,ADDRESS_1,MANAGER,DATE_OPEN,OPEN,OWNED_OUTRIGHT,FLOOR_SPACE,ZIP_CODE,CITY,STATE,SHOP_CODE)
VALUES
	('e-Fashion Londres','90 Oxford Street','Hafsa',TO_DATE('02/01/18', 'dd/mm/yy'),'Y','Y',1500,000000,'Londres','Londres',354);

INSERT INTO OUTLET_LOOKUP
    (SHOP_NAME,ADDRESS_1,MANAGER,DATE_OPEN,OPEN,OWNED_OUTRIGHT,FLOOR_SPACE,ZIP_CODE,CITY,STATE,SHOP_CODE)
VALUES
	('e-Fashion Casablanca','9 Rue maarif','Youness',TO_DATE('02/01/18', 'dd/mm/yy'),'Y','Y',1500,000000,'Casablanca','Casablanca',355);

commit;
	
-- -------------------- --
-- ARTICLE_LOOKUP --
-- -------------------- --

INSERT INTO ARTICLE_LOOKUP
	(ARTICLE_CODE,ARTICLE_LABEL,CATEGORY,SALE_PRICE,FAMILY_NAME,FAMILY_CODE)
VALUES
	(189480,'Longline T-Shirts','T-Shirts',26.99,'Sweat-T-Shirts','F36');
	
INSERT INTO ARTICLE_LOOKUP
	(ARTICLE_CODE,ARTICLE_LABEL,CATEGORY,SALE_PRICE,FAMILY_NAME,FAMILY_CODE)
VALUES
	(189481,'Long Short','Bermudas',24.99,'City Trousers','F2');

INSERT INTO ARTICLE_LOOKUP
	(ARTICLE_CODE,ARTICLE_LABEL,CATEGORY,SALE_PRICE,FAMILY_NAME,FAMILY_CODE)
VALUES
	(189482,'Article X','Bermudas',24.99,'City Trousers','F2');

commit;	
	
-- -------------------- --
-- ARTICLE_COLOR_LOOKUP --
-- -------------------- --

INSERT INTO ARTICLE_COLOR_LOOKUP
	(ARTICLE_CODE,COLOR_CODE,ARTICLE_LABEL,COLOR_LABEL,CATEGORY,SALE_PRICE,FAMILY_NAME,FAMILY_CODE)
VALUES
	(189480,901,'Longline T-Shirts','White','T-Shirts',26.99,'Sweat-T-Shirts','F36');

INSERT INTO ARTICLE_COLOR_LOOKUP
	(ARTICLE_CODE,COLOR_CODE,ARTICLE_LABEL,COLOR_LABEL,CATEGORY,SALE_PRICE,FAMILY_NAME,FAMILY_CODE)
VALUES
	(189481,902,'Long Short','Black','Bermudas',24.99,'City Trousers','F2');

INSERT INTO ARTICLE_COLOR_LOOKUP
	(ARTICLE_CODE,COLOR_CODE,ARTICLE_LABEL,COLOR_LABEL,CATEGORY,SALE_PRICE,FAMILY_NAME,FAMILY_CODE)
VALUES
	(189482,902,'Article X','Black','Bermudas',24.99,'City Trousers','F2');
commit;

-- -------------------- --
-- SHOP_FACTS		    --
-- -------------------- --

INSERT INTO SHOP_FACTS
	(ID,ARTICLE_CODE,COLOR_CODE,WEEK_KEY,SHOP_CODE,MARGIN,AMOUNT_SOLD,QUANTITY_SOLD)
VALUES
	(89172,189480,901,263,353,125,151.99,1);
	

INSERT INTO SHOP_FACTS
	(ID,ARTICLE_CODE,COLOR_CODE,WEEK_KEY,SHOP_CODE,MARGIN,AMOUNT_SOLD,QUANTITY_SOLD)
VALUES
	(89173,189481,902,263,354,100,124.99,1);

INSERT INTO SHOP_FACTS
	(ID,ARTICLE_CODE,COLOR_CODE,WEEK_KEY,SHOP_CODE,MARGIN,AMOUNT_SOLD,QUANTITY_SOLD)
VALUES
	(89174,189479,119,263,353,247.3,501.5,1);

INSERT INTO SHOP_FACTS
	(ID,ARTICLE_CODE,COLOR_CODE,WEEK_KEY,SHOP_CODE,MARGIN,AMOUNT_SOLD,QUANTITY_SOLD)
VALUES
	(89175,189482,902,263,353,247.3,501.5,1);		

commit;
	