-- -------------------- --
-- CALENDAR_YEAR_LOOKUP --
-- -------------------- --

UPDATE CALENDAR_YEAR_LOOKUP
SET HOLIDAY_FLAG = 'y'
WHERE WEEK_KEY = 264;
commit;

-- -------------------- --
-- OULTET_LOOKUP 		--
-- -------------------- --

UPDATE OUTLET_LOOKUP
SET MANAGER = 'Khalid'
WHERE SHOP_CODE = 353;
commit;
	
-- -------------------- --
-- ARTICLE_LOOKUP --
-- -------------------- --

UPDATE ARTICLE_LOOKUP
SET ARTICLE_LABEL = 'test update'
WHERE ARTICLE_CODE = 189480;
commit;
	
	
-- -------------------- --
-- ARTICLE_COLOR_LOOKUP --
-- -------------------- --

UPDATE ARTICLE_COLOR_LOOKUP
SET ARTICLE_LABEL = 'test update'
WHERE ARTICLE_CODE = 189480
AND COLOR_CODE = 901;
commit;

-- -------------------- --
-- SHOP_FACTS		    --
-- -------------------- --
	
UPDATE SHOP_FACTS
SET AMOUNT_SOLD = 500
WHERE ID = 89175;
commit;
	
	