-- -------------------- --
-- ARTICLE_COLOR_LOOKUP --
-- -------------------- --
SELECT 
	ACL.ARTICLE_CODE AS "Article code"
	,ACL.COLOR_CODE AS "Color code"
	,CONCAT(ACL.ARTICLE_CODE,ACL.COLOR_CODE) AS "Article_Color_Code"
	,COUNT(CONCAT(ACL.ARTICLE_CODE,ACL.COLOR_CODE)) AS "Nombre de clés primaires"
FROM 
	ARTICLE_COLOR_LOOKUP ACL 
GROUP BY
	ACL.ARTICLE_CODE 
	,ACL.COLOR_CODE
	,CONCAT(ACL.ARTICLE_CODE,ACL.COLOR_CODE)
HAVING 
	COUNT(CONCAT(ACL.ARTICLE_CODE,ACL.COLOR_CODE))  > 1 
ORDER BY 
	1 ASC
;
-- -------------- --
-- ARTICLE_LOOKUP --
-- -------------- --
SELECT 
    AL.ARTICLE_CODE "ARTICLE_CODE",
    COUNT(AL.ARTICLE_CODE) "Nombre de clés primaires"
FROM
    ARTICLE_LOOKUP AL
GROUP BY
    AL.ARTICLE_CODE
HAVING 
    COUNT(AL.ARTICLE_CODE) > 1
ORDER BY
    1 ASC
 ;
-- -------------------- --
-- CALENDAR_YEAR_LOOKUP --
-- -------------------- --
SELECT
	CYL.WEEK_KEY "Week key"
	,COUNT(CYL.WEEK_KEY) "Nombre de clés primaires"
FROM
	CALENDAR_YEAR_LOOKUP CYL
GROUP BY
	CYL.WEEK_KEY
HAVING
	COUNT(CYL.WEEK_KEY) > 1
ORDER BY
	1 ASC
;
-- ------------- --
-- OULTET_LOOKUP --
-- ------------- --
SELECT 
	OL.SHOP_CODE AS "Shop_Code"
	, COUNT(OL.SHOP_CODE) AS "Nombre de clés primaires"
FROM 
	OUTLET_LOOKUP OL
GROUP BY
	OL.SHOP_CODE
HAVING
	COUNT(OL.SHOP_CODE) > 1 
ORDER BY 
	1 ASC
;
-- ---------- --
-- SHOP_FACTS --
-- ---------- --
SELECT
	SH.ID AS "ID"
	, COUNT(SH.ID) AS "Nombre de clés primaires"
FROM
	SHOP_FACTS SH
GROUP BY 
	SH.ID
HAVING
	COUNT(SH.ID) > 1
ORDER BY 
	1 ASC
;