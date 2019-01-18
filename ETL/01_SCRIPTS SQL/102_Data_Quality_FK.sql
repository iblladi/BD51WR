-- ---------------------------- --
-- ARTICLE_LOOKUP -> SHOP_FACTS --
-- ---------------------------- --
SELECT
	ARTICLE_CODE
FROM
	SHOP_FACTS
WHERE 
	ARTICLE_CODE
NOT IN (SELECT ARTICLE_CODE FROM ARTICLE_LOOKUP);

-- ---------------------------------- --
-- ARTICLE_COLOR_LOOKUP -> SHOP_FACTS --
-- ---------------------------------- --
SELECT
	DISTINCT ARTICLE_CODE||COLOR_CODE
FROM
	SHOP_FACTS
WHERE 
	ARTICLE_CODE||COLOR_CODE
NOT IN (SELECT ARTICLE_CODE||COLOR_CODE FROM ARTICLE_COLOR_LOOKUP);

-- ---------------------------------- --
-- CALENDAR_YEAR_LOOKUP -> SHOP_FACTS --
-- ---------------------------------- --
SELECT
	WEEK_KEY
FROM
	SHOP_FACTS
WHERE 
	WEEK_KEY
NOT IN (SELECT WEEK_KEY FROM CALENDAR_YEAR_LOOKUP);

-- --------------------------- --
-- OUTLET_LOOKUP -> SHOP_FACTS --
-- ---------------------------- --
SELECT
	SHOP_CODE
FROM
	SHOP_FACTS
WHERE 
	SHOP_CODE
NOT IN (SELECT SHOP_CODE FROM OUTLET_LOOKUP);