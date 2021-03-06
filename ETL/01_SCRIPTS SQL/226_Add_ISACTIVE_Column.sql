-- -------------------- --
-- ARTICLE_COLOR_LOOKUP --
-- -------------------- --
ALTER TABLE ARTICLE_COLOR_LOOKUP
ADD ISACTIVE NUMERIC(1) NULL
ALTER TABLE ARTICLE_COLOR_LOOKUP
ADD CONSTRAINT CST_DFLT_ACL
DEFAULT 1 FOR ISACTIVE

-- -------------------- --
-- ARTICLE_LOOKUP --
-- -------------------- --
ALTER TABLE ARTICLE_LOOKUP
ADD ISACTIVE NUMERIC(1) NULL
ALTER TABLE ARTICLE_LOOKUP
ADD CONSTRAINT CST_DFLT_AL
DEFAULT 1 FOR ISACTIVE

-- -------------------- --
-- OULTET_LOOKUP --
-- -------------------- --
ALTER TABLE OUTLET_LOOKUP
ADD ISACTIVE NUMERIC(1) NULL
ALTER TABLE OUTLET_LOOKUP
ADD CONSTRAINT CST_DFLT_OL
DEFAULT 1 FOR ISACTIVE

-- -------------------- --
-- CALENDAR_YEAR_LOOKUP --
-- -------------------- --
ALTER TABLE CALENDAR_YEAR_LOOKUP
ADD ISACTIVE NUMERIC(1) NULL
ALTER TABLE CALENDAR_YEAR_LOOKUP
ADD CONSTRAINT CST_DFLT_CYL
DEFAULT 1 FOR ISACTIVE