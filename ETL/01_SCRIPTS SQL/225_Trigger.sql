-- After insert
CREATE OR REPLACE TRIGGER "EMODE"."SHOP_FACTS_TAI" 
AFTER INSERT ON EMODE.SHOP_FACTS
FOR EACH ROW
DECLARE
	rowsdetected NUMBER(10);
	operationtype VARCHAR2(6);
	idsf NUMBER(10);
BEGIN
	-- If PK is null then initialize idsf to 0	
	IF(:new.ID IS NULL) THEN
		idsf := 0;
	ELSE
		idsf := :new.ID;
	END IF; 
  	-- Insert the number of rows existed in SHOP_FACTS_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.SHOP_FACTS_INC SFI
	WHERE
		SFI.ID = idsf;
   	-- If no row then insert
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.SHOP_FACTS_INC
		(
			ID
			,ARTICLE_CODE
			,COLOR_CODE
			,WEEK_KEY
			,SHOP_CODE
			,MARGIN
			,AMOUNT_SOLD
			,QUANTITY_SOLD
			,OPERATION_TYPE
		)
		VALUES
		(
			:new.ID
			,:new.ARTICLE_CODE
			,:new.COLOR_CODE
			,:new.WEEK_KEY
			,:new.SHOP_CODE
			,:new.MARGIN
			,:new.AMOUNT_SOLD
			,:new.QUANTITY_SOLD
			,'INSERT'
		);
	-- Else Get operation type from SHOP_FACTS_INC
	ELSE
        	SELECT
          		OPERATION_TYPE INTO operationtype
         	FROM
           		EMODE_INC.SHOP_FACTS_INC SFI
        	WHERE
          		SFI.ID = idsf;
        --IF opration type is 'DELETE' THEN change it to 'UPDATE' and update other columns else update rows
        	IF(operationtype='DELETE') THEN
			UPDATE 
				EMODE_INC.SHOP_FACTS_INC
			SET 
				ID = :new.ID
				,ARTICLE_CODE = :new.ARTICLE_CODE
				,COLOR_CODE = :new.COLOR_CODE
				,WEEK_KEY = :new.WEEK_KEY
				,SHOP_CODE = :new.SHOP_CODE
				,MARGIN = :new.MARGIN
				,AMOUNT_SOLD = :new.AMOUNT_SOLD
				,QUANTITY_SOLD = :new.QUANTITY_SOLD
				,OPERATION_TYPE = 'UPDATE'
			WHERE 
				ID = idsf;
		ELSE
			UPDATE 
				EMODE_INC.SHOP_FACTS_INC
			SET 
				ID = :new.ID
				,ARTICLE_CODE = :new.ARTICLE_CODE
				,COLOR_CODE = :new.COLOR_CODE
				,WEEK_KEY = :new.WEEK_KEY
				,SHOP_CODE = :new.SHOP_CODE
				,MARGIN = :new.MARGIN
				,AMOUNT_SOLD = :new.AMOUNT_SOLD
				,QUANTITY_SOLD = :new.QUANTITY_SOLD
				,OPERATION_TYPE = operationtype
			WHERE 
				ID = idsf;
        	END IF;
	END IF;
  
END SHOP_FACTS_TAI;
/
ALTER TRIGGER "EMODE"."SHOP_FACTS_TAI" ENABLE;
-- After update
CREATE OR REPLACE TRIGGER "EMODE"."SHOP_FACTS_TAU" 
AFTER UPDATE ON EMODE.SHOP_FACTS
FOR EACH ROW
DECLARE
	rowsdetected NUMBER;
	operationtype VARCHAR2(6);
	idsf NUMBER(10);
BEGIN	
	-- If PK is null then initialize idsf to 0
	IF(:new.ID IS NULL) THEN
		 idsf := 0;
	ELSE
		idsf := :new.ID;
	END IF;
  	-- Insert the number of rows existed in SHOP_FACTS_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.SHOP_FACTS_INC
	WHERE
		ID = :old.ID;
	-- Test PK modification	
	IF(:old.ID <> idsf) THEN 
  
    -- Delete old existed lines in EMODE_INC
    IF (rowsdetected > 0) THEN
    DELETE FROM EMODE_INC.SHOP_FACTS_INC
    WHERE ID = :old.ID;
    END IF;
    
		-- insert to Delete type old lines
		INSERT INTO EMODE_INC.SHOP_FACTS_INC
		(
			ID
			,ARTICLE_CODE
			,COLOR_CODE
			,WEEK_KEY
			,SHOP_CODE
			,MARGIN
			,AMOUNT_SOLD
			,QUANTITY_SOLD
			,OPERATION_TYPE
		)
		VALUES
		(
			:old.ID
			,:old.ARTICLE_CODE
			,:old.COLOR_CODE
			,:old.WEEK_KEY
			,:old.SHOP_CODE
			,:old.MARGIN
			,:old.AMOUNT_SOLD
			,:old.QUANTITY_SOLD
			,'DELETE'
		);
		
		-- Insert with new PK
		INSERT INTO EMODE_INC.SHOP_FACTS_INC
		(
			ID
			,ARTICLE_CODE
			,COLOR_CODE
			,WEEK_KEY
			,SHOP_CODE
			,MARGIN
			,AMOUNT_SOLD
			,QUANTITY_SOLD
			,OPERATION_TYPE
		)
		VALUES
		(
			:new.ID
			,:new.ARTICLE_CODE
			,:new.COLOR_CODE
			,:new.WEEK_KEY
			,:new.SHOP_CODE
			,:new.MARGIN
			,:new.AMOUNT_SOLD
			,:new.QUANTITY_SOLD
			,'INSERT'
		);
	-- If no old PK then update other data
	ELSE
		IF(rowsdetected=0) THEN
			INSERT INTO EMODE_INC.SHOP_FACTS_INC
			(
				ID
				,ARTICLE_CODE
				,COLOR_CODE
				,WEEK_KEY
				,SHOP_CODE
				,MARGIN
				,AMOUNT_SOLD
				,QUANTITY_SOLD
				,OPERATION_TYPE
			)
			VALUES
			(
				:new.ID
				,:new.ARTICLE_CODE
				,:new.COLOR_CODE
				,:new.WEEK_KEY
				,:new.SHOP_CODE
				,:new.MARGIN
				,:new.AMOUNT_SOLD
				,:new.QUANTITY_SOLD
				,'UPDATE'
			);
		ELSE
			SELECT
				OPERATION_TYPE INTO operationtype
			FROM
				EMODE_INC.SHOP_FACTS_INC SFI
			WHERE
				SFI.ID = idsf;
        
			UPDATE 
				EMODE_INC.SHOP_FACTS_INC
			SET 
				ID = :new.ID
				,ARTICLE_CODE = :new.ARTICLE_CODE
				,COLOR_CODE = :new.COLOR_CODE
				,WEEK_KEY = :new.WEEK_KEY
				,SHOP_CODE = :new.SHOP_CODE
				,MARGIN = :new.MARGIN
				,AMOUNT_SOLD = :new.AMOUNT_SOLD
				,QUANTITY_SOLD = :new.QUANTITY_SOLD
				,OPERATION_TYPE = operationtype
			WHERE 
				ID = idsf;
		END IF; 
	END IF;
END SHOP_FACTS_TAU;
/
ALTER TRIGGER "EMODE"."SHOP_FACTS_TAU" ENABLE;
-- After delete
CREATE OR REPLACE TRIGGER "EMODE"."SHOP_FACTS_TAD" 
AFTER DELETE ON EMODE.SHOP_FACTS
FOR EACH ROW
DECLARE
	rowsdetected NUMBER(10);
	operationtype VARCHAR2(6);
	idsf NUMBER(10);
BEGIN
	-- If PK is null then initialize idsf to 0
	IF(:old.ID IS NULL) THEN
		idsf := 0;
	ELSE
		idsf := :old.ID;
	END IF; 
  
	-- Insert the number of rows existed in SHOP_FACTS_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.SHOP_FACTS_INC SFI
	WHERE
		SFI.ID = idsf;
	-- If no row then insert with delete operation type
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.SHOP_FACTS_INC
		(
			ID
			,ARTICLE_CODE
			,COLOR_CODE
			,WEEK_KEY
			,SHOP_CODE
			,MARGIN
			,AMOUNT_SOLD
			,QUANTITY_SOLD
			,OPERATION_TYPE
		)
		VALUES
		(
			:old.ID
			,:old.ARTICLE_CODE
			,:old.COLOR_CODE
			,:old.WEEK_KEY
			,:old.SHOP_CODE
			,:old.MARGIN
			,:old.AMOUNT_SOLD
			,:old.QUANTITY_SOLD
			,'DELETE'
		);
	-- Else Get operation type from SHOP_FACTS_INC
	ELSE
        SELECT
          OPERATION_TYPE INTO operationtype
         FROM
           EMODE_INC.SHOP_FACTS_INC SFI
        WHERE
          SFI.ID = idsf;
        -- If operation type 'INSERT'then delete lines
        IF(operationtype='INSERT') THEN
            DELETE FROM EMODE_INC.SHOP_FACTS_INC 
			WHERE ID = :old.ID;
	-- Else moficate lines data
        ELSE   
            UPDATE EMODE_INC.SHOP_FACTS_INC
            SET OPERATION_TYPE = 'DELETE'
            WHERE ID = idsf;
        END IF;
	END IF;
  
END SHOP_FACTS_TAD;
/
ALTER TRIGGER "EMODE"."SHOP_FACTS_TAD" ENABLE;

-- After insert
CREATE OR REPLACE TRIGGER "EMODE"."OUTLET_LOOKUP_TAI" 
AFTER INSERT ON EMODE.OUTLET_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER;
	operationtype VARCHAR2(6);
	shopcode NUMBER(10);
BEGIN
	-- If PK is null then initialize shopcode to 0	
	IF(:new.SHOP_CODE IS NULL) THEN
		shopcode := 0;
	ELSE
		shopcode := :new.SHOP_CODE;
	END IF; 
 	-- Insert the number of rows existed in OUTLET_LOOKUP_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.outlet_lookup_INC OLI
	WHERE
		OLI.SHOP_CODE = shopcode;
   	-- If no row then insert
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.OUTLET_LOOKUP_INC
		(
			SHOP_NAME
			,ADDRESS_1,MANAGER
			,DATE_OPEN
			,OPEN
			,OWNED_OUTRIGHT
			,FLOOR_SPACE
			,ZIP_CODE
			,CITY
			,STATE
			,SHOP_CODE
			,OPERATION_TYPE
		)
		VALUES
		(
			:new.SHOP_NAME
			,:new.ADDRESS_1
			,:new.MANAGER
			,:new.DATE_OPEN
			,:new.OPEN
			,:new.OWNED_OUTRIGHT
			,:new.FLOOR_SPACE
			,:new.ZIP_CODE
			,:new.CITY
			,:new.STATE
			,shopcode
			,'INSERT'
		);
	-- Else Get operation type from OUTLET_LOOKUP_INC
	ELSE
        	SELECT
         		OPERATION_TYPE INTO operationtype
         	FROM
         		EMODE_INC.outlet_lookup_INC OLI
       		WHERE
			OLI.SHOP_CODE = shopcode;
       	--IF opration type is 'DELETE' THEN change it to 'UPDATE' and update other columns else update rows
        IF(operationtype='DELETE') THEN
			UPDATE EMODE_INC.OUTLET_LOOKUP_INC
			SET	
				SHOP_NAME = :new.SHOP_NAME
				,ADDRESS_1 = :new.ADDRESS_1
				,MANAGER = :new.MANAGER
				,DATE_OPEN = :new.DATE_OPEN
				,OPEN = :new.OPEN
				,OWNED_OUTRIGHT = :new.OWNED_OUTRIGHT
				,FLOOR_SPACE = :new.FLOOR_SPACE
				,ZIP_CODE = :new.ZIP_CODE
				,CITY = :new.CITY
				,STATE = :new.STATE
				,SHOP_CODE = shopcode
				,OPERATION_TYPE = 'UPDATE'
			WHERE 
				SHOP_CODE = shopcode;
		ELSE   
			UPDATE EMODE_INC.OUTLET_LOOKUP_INC
			SET	
				SHOP_NAME = :new.SHOP_NAME
				,ADDRESS_1 = :new.ADDRESS_1
				,MANAGER = :new.MANAGER
				,DATE_OPEN = :new.DATE_OPEN
				,OPEN = :new.OPEN
				,OWNED_OUTRIGHT = :new.OWNED_OUTRIGHT
				,FLOOR_SPACE = :new.FLOOR_SPACE
				,ZIP_CODE = :new.ZIP_CODE
				,CITY = :new.CITY
				,STATE = :new.STATE
				,SHOP_CODE = shopcode
				,OPERATION_TYPE = operationtype
			WHERE 
				SHOP_CODE = shopcode;
		END IF;
	END IF;
END OUTLET_LOOKUP_TAI;
/
ALTER TRIGGER "EMODE"."OUTLET_LOOKUP_TAI" ENABLE;
--After update
CREATE OR REPLACE TRIGGER "EMODE"."OUTLET_LOOKUP_TAU" 
AFTER UPDATE ON EMODE.OUTLET_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER;
	operationtype VARCHAR2(6);
	shopcode NUMBER(10);
  	rowsdetectedSF NUMBER(10);
BEGIN
	-- If PK is null then initialize shopcode to 0
	IF(:new.SHOP_CODE IS NULL) THEN
		shopcode := 0;
	ELSE
		shopcode := :new.SHOP_CODE;
	END IF;
  
	-- Insert the number of rows existed in OUTLET_LOOKUP_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.outlet_lookup_INC OLI
	WHERE
		OLI.SHOP_CODE = :old.SHOP_CODE;
  
	-- Test PK modification
	IF(:old.SHOP_CODE <> shopcode) THEN 
		-- Test existance of outlet in SHOP_FACTS 
		SELECT 
			COUNT(*) INTO rowsdetectedSF
		FROM 
			EMODE.SHOP_FACTS
		WHERE 
			SHOP_CODE = :old.SHOP_CODE;
		
		-- If exist then update
		IF (rowsdetectedSF > 0) THEN
			UPDATE EMODE.SHOP_FACTS 
			SET SHOP_CODE = shopcode
			WHERE SHOP_CODE = :old.SHOP_CODE;
   		END IF;   
      
    		-- Delete old existed lines in EMODE_INC
    		IF (rowsdetected > 0) THEN
    			DELETE FROM EMODE_INC.OUTLET_LOOKUP_INC
    				WHERE SHOP_CODE = :old.SHOP_CODE;
   		END IF;
    
		-- insert to Delete old outlets
		INSERT INTO EMODE_INC.OUTLET_LOOKUP_INC
			(
			SHOP_NAME
			,ADDRESS_1
			,MANAGER
			,DATE_OPEN
			,OPEN
			,OWNED_OUTRIGHT
			,FLOOR_SPACE
			,ZIP_CODE
			,CITY
			,STATE
			,SHOP_CODE
			,OPERATION_TYPE
			)
			VALUES
			(
			:old.SHOP_NAME
			,:old.ADDRESS_1
			,:old.MANAGER
			,:old.DATE_OPEN
			,:old.OPEN
			,:old.OWNED_OUTRIGHT
			,:old.FLOOR_SPACE
			,:old.ZIP_CODE
			,:old.CITY
			,:old.STATE
			,:old.SHOP_CODE
			,'DELETE'
			);
    
			-- Insert outlets with new PK
		INSERT INTO EMODE_INC.OUTLET_LOOKUP_INC
			(
			SHOP_NAME
			,ADDRESS_1
			,MANAGER
			,DATE_OPEN
			,OPEN
			,OWNED_OUTRIGHT
			,FLOOR_SPACE
			,ZIP_CODE
			,CITY
			,STATE
			,SHOP_CODE
			,OPERATION_TYPE
			)
			VALUES
			(
			:new.SHOP_NAME
			,:new.ADDRESS_1
			,:new.MANAGER
			,:new.DATE_OPEN
			,:new.OPEN
			,:new.OWNED_OUTRIGHT
			,:new.FLOOR_SPACE
			,:new.ZIP_CODE
			,:new.CITY
			,:new.STATE
			,shopcode
			,'INSERT'
			);
	-- If no old PK then update other data  
	ELSE
		IF(rowsdetected=0) THEN
			INSERT INTO EMODE_INC.OUTLET_LOOKUP_INC
				(
				SHOP_NAME
				,ADDRESS_1
				,MANAGER
				,DATE_OPEN
				,OPEN
				,OWNED_OUTRIGHT
				,FLOOR_SPACE
				,ZIP_CODE
				,CITY
				,STATE
				,SHOP_CODE
				,OPERATION_TYPE
				)
				VALUES
				(
				:new.SHOP_NAME
				,:new.ADDRESS_1
				,:new.MANAGER
				,:new.DATE_OPEN
				,:new.OPEN
				,:new.OWNED_OUTRIGHT
				,:new.FLOOR_SPACE
				,:new.ZIP_CODE
				,:new.CITY
				,:new.STATE
				,shopcode
				,'UPDATE'
				);
		ELSE
			SELECT
				OPERATION_TYPE INTO operationtype
			FROM
				EMODE_INC.outlet_lookup_INC OLI
			WHERE
				OLI.SHOP_CODE = shopcode;
        
			UPDATE 
				EMODE_INC.OUTLET_LOOKUP_INC
			SET	
				SHOP_NAME = :new.SHOP_NAME
				,ADDRESS_1 = :new.ADDRESS_1
				,MANAGER = :new.MANAGER
				,DATE_OPEN = :new.DATE_OPEN
				,OPEN = :new.OPEN
				,OWNED_OUTRIGHT = :new.OWNED_OUTRIGHT
				,FLOOR_SPACE = :new.FLOOR_SPACE
				,ZIP_CODE = :new.ZIP_CODE
				,CITY = :new.CITY
				,STATE = :new.STATE
				,SHOP_CODE = shopcode
				,OPERATION_TYPE = operationtype
			WHERE 
				SHOP_CODE = shopcode;
		END IF; 
	END IF; 
END OUTLET_LOOKUP_TAU;
/
ALTER TRIGGER "EMODE"."OUTLET_LOOKUP_TAU" ENABLE;
-- After delete
CREATE OR REPLACE TRIGGER "EMODE"."OUTLET_LOOKUP_TAD" 
AFTER DELETE ON EMODE.OUTLET_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER(10);
	operationtype VARCHAR2(6);
	shopcode NUMBER(10);
BEGIN
	-- If PK is null then initialize shopcode to 0
	IF(:old.SHOP_CODE IS NULL) THEN
		shopcode := 0;
	ELSE
		shopcode := :old.SHOP_CODE;
	END IF; 
	
	-- Insert the number of rows existed in OUTLET_LOOKUP_INC that have the PK
    SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.outlet_lookup_INC OLI
	WHERE
		OLI.SHOP_CODE = shopcode;
		
   
	-- If no row then insert with delete operation type
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.OUTLET_LOOKUP_INC
		(
			SHOP_NAME
			,ADDRESS_1
			,MANAGER
			,DATE_OPEN
			,OPEN
			,OWNED_OUTRIGHT
			,FLOOR_SPACE
			,ZIP_CODE
			,CITY
			,STATE
			,SHOP_CODE
			,OPERATION_TYPE
		)
		VALUES
		(
			:old.SHOP_NAME
			,:old.ADDRESS_1
			,:old.MANAGER
			,:old.DATE_OPEN
			,:old.OPEN
			,:old.OWNED_OUTRIGHT
			,:old.FLOOR_SPACE
			,:old.ZIP_CODE
			,:old.CITY
			,:old.STATE
			,shopcode
			,'DELETE'
		);
	-- Else Get operation type from OUTLET_LOOKUP_INC
	ELSE
        SELECT
          OPERATION_TYPE INTO operationtype
         FROM
           EMODE_INC.outlet_lookup_INC OLI
        WHERE
        OLI.SHOP_CODE = shopcode;
        
		-- If operation type 'INSERT'then delete lines
        IF(operationtype='INSERT') THEN
            DELETE FROM EMODE_INC.OUTLET_LOOKUP_INC 
			WHERE SHOP_CODE = :old.SHOP_CODE;
	-- Else moficate lines data
        ELSE   
            UPDATE EMODE_INC.OUTLET_LOOKUP_INC
            SET OPERATION_TYPE = 'DELETE'
            WHERE SHOP_CODE = shopcode;
        END IF;
	END IF;

  
END OUTLET_LOOKUP_TAD;
/
ALTER TRIGGER "EMODE"."OUTLET_LOOKUP_TAD" ENABLE;
-- ARTICLE_LOOKUP triggers
-- After insert
CREATE OR REPLACE TRIGGER "EMODE"."ARTICLE_LOOKUP_TAI"
AFTER INSERT ON EMODE.ARTICLE_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER;
	operationtype VARCHAR2(6);
	articlecode NUMBER(10);
BEGIN
	-- If PK is null then initialize articlecode to 0		
	IF(:new.ARTICLE_CODE IS NULL) THEN
		articlecode := 0;
	ELSE
		articlecode := :new.ARTICLE_CODE;
	END IF; 
  	-- Insert the number of rows existed in ARTICLE_LOOKUP_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.ARTICLE_LOOKUP_INC
	WHERE
		ARTICLE_CODE = articlecode;
   	-- If no row then insert
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.ARTICLE_LOOKUP_INC
		(
          		ARTICLE_CODE
			,ARTICLE_LABEL
      			,CATEGORY
      			,SALE_PRICE
      			,FAMILY_NAME
      			,FAMILY_CODE
			,OPERATION_TYPE
		)
		VALUES
		(
      			articlecode
			,:new.ARTICLE_LABEL
      			,:new.CATEGORY
      			,:new.SALE_PRICE
      			,:new.FAMILY_NAME
      			,:new.FAMILY_CODE
			,'INSERT'
		);
	-- Else Get operation type from ARTICLE_LOOKUP_INC
	ELSE
        SELECT
          OPERATION_TYPE INTO operationtype
         FROM
           EMODE_INC.ARTICLE_LOOKUP_INC
        WHERE
          ARTICLE_CODE = articlecode;
        --IF opration type is 'DELETE' THEN change it to 'UPDATE' and update other columns else update rows
        IF(operationtype='DELETE') THEN
		UPDATE EMODE_INC.ARTICLE_LOOKUP_INC
		SET	
        		ARTICLE_CODE = articlecode
        		,ARTICLE_LABEL = :new.ARTICLE_LABEL
        		,CATEGORY = :new.CATEGORY
        		,SALE_PRICE = :new.SALE_PRICE
        		,FAMILY_NAME = :new.FAMILY_NAME
        ,		FAMILY_CODE = :new.FAMILY_CODE
			,OPERATION_TYPE = 'UPDATE'
		WHERE 
			ARTICLE_CODE = articlecode;
	ELSE   
		UPDATE EMODE_INC.ARTICLE_LOOKUP_INC
		SET	
    			ARTICLE_CODE = articlecode
      			,ARTICLE_LABEL = :new.ARTICLE_LABEL
       			,CATEGORY = :new.CATEGORY
       			,SALE_PRICE = :new.SALE_PRICE
       			,FAMILY_NAME = :new.FAMILY_NAME
       			,FAMILY_CODE = :new.FAMILY_CODE
			,OPERATION_TYPE = operationtype
		WHERE 
			ARTICLE_CODE = articlecode;
		END IF;
	END IF;
END ARTICLE_LOOKUP_TAI;
/
ALTER TRIGGER "EMODE"."ARTICLE_LOOKUP_TAI" ENABLE;
-- After update
CREATE OR REPLACE TRIGGER "EMODE"."ARTICLE_LOOKUP_TAU" 
AFTER UPDATE ON EMODE.ARTICLE_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER;
	operationtype VARCHAR2(6);
	articlecode NUMBER(10);
  	rowsdetectedSF NUMBER(10);
BEGIN
	-- If PK is null then initialize articlecode to 0
	IF(:new.ARTICLE_CODE IS NULL) THEN
		articlecode := 0;
	ELSE
		articlecode := :new.ARTICLE_CODE;
	END IF;
  
	-- Insert the number of rows existed in ARTICLE_LOOKUP_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.ARTICLE_LOOKUP_INC
	WHERE
		ARTICLE_CODE = :old.ARTICLE_CODE;
  
	-- Test PK modification
	IF(:old.ARTICLE_CODE <> articlecode) THEN 
		-- Test existance of article in SHOP_FACTS
		SELECT 
			COUNT(*) INTO rowsdetectedSF
		FROM 
			EMODE.SHOP_FACTS
		WHERE 
			ARTICLE_CODE = :old.ARTICLE_CODE;
		
		-- If exist then update
		IF (rowsdetectedSF > 0) THEN
			UPDATE EMODE.SHOP_FACTS 
			SET ARTICLE_CODE = :new.ARTICLE_CODE
			WHERE ARTICLE_CODE = :old.ARTICLE_CODE;
    		END IF;  
      
   	 	-- Delete old existed lines in EMODE_INC
    		IF (rowsdetected > 0) THEN
    			DELETE FROM EMODE_INC.ARTICLE_LOOKUP_INC
    			WHERE ARTICLE_CODE = :old.ARTICLE_CODE;
    		END IF;
    
		-- insert to Delete old articles
		INSERT INTO EMODE_INC.ARTICLE_LOOKUP_INC
			(
      			ARTICLE_CODE
			,ARTICLE_LABEL
      			,CATEGORY
      			,SALE_PRICE
      			,FAMILY_NAME
      			,FAMILY_CODE
			,OPERATION_TYPE
			)
			VALUES
			(
      			articlecode
			,:old.ARTICLE_LABEL
      			,:old.CATEGORY
      			,:old.SALE_PRICE
      			,:old.FAMILY_NAME
      			,:old.FAMILY_CODE
			,'DELETE'
			);
    
		-- Insert articles with new PK
		INSERT INTO EMODE_INC.ARTICLE_LOOKUP_INC
			(
      			ARTICLE_CODE
			,ARTICLE_LABEL
      			,CATEGORY
      			,SALE_PRICE
      			,FAMILY_NAME
      			,FAMILY_CODE
			,OPERATION_TYPE
			)
			VALUES
			(
     		 	articlecode
			,:new.ARTICLE_LABEL
      			,:new.CATEGORY
      			,:new.SALE_PRICE
      			,:new.FAMILY_NAME
      			,:new.FAMILY_CODE
			,'INSERT'
		); 
	-- If no old PK then update other data
	ELSE 
		IF(rowsdetected=0) THEN
			INSERT INTO EMODE_INC.ARTICLE_LOOKUP_INC
				(
	      			ARTICLE_CODE
       				,ARTICLE_LABEL
        			,CATEGORY
        			,SALE_PRICE
        			,FAMILY_NAME
        			,FAMILY_CODE
        			,OPERATION_TYPE
				)
				VALUES
				(
       				articlecode
       			 	,:new.ARTICLE_LABEL
        			,:new.CATEGORY
       				 ,:new.SALE_PRICE
        			,:new.FAMILY_NAME
        			,:new.FAMILY_CODE
        			,'UPDATE'
			);
		ELSE
			SELECT
				OPERATION_TYPE INTO operationtype
			FROM
				EMODE_INC.ARTICLE_LOOKUP_INC
			WHERE
				ARTICLE_CODE = articlecode;
        
			UPDATE 
				EMODE_INC.ARTICLE_LOOKUP_INC
			SET	
         			ARTICLE_CODE = articlecode
        			,ARTICLE_LABEL = :new.ARTICLE_LABEL
        			,CATEGORY = :new.CATEGORY
        			,SALE_PRICE = :new.SALE_PRICE
        			,FAMILY_NAME = :new.FAMILY_NAME
        			,FAMILY_CODE = :new.FAMILY_CODE
				,OPERATION_TYPE = operationtype
			WHERE 
				ARTICLE_CODE = articlecode;
		END IF; 
	END IF; 
END ARTICLE_LOOKUP_TAU;
/
ALTER TRIGGER "EMODE"."ARTICLE_LOOKUP_TAU" ENABLE;
--After delete
CREATE OR REPLACE TRIGGER "EMODE"."ARTICLE_LOOKUP_TAD" 
AFTER DELETE ON EMODE.ARTICLE_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER(10);
	operationtype VARCHAR2(6);
	articlecode NUMBER(10);
BEGIN
	-- If PK is null then initialize articlecode to 0
	IF(:old.ARTICLE_CODE IS NULL) THEN
		articlecode := 0;
	ELSE
		articlecode := :old.ARTICLE_CODE;
	END IF; 
	
	-- Insert the number of rows existed in ARTICLE_LOOKUP_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.ARTICLE_LOOKUP_INC 
	WHERE
		ARTICLE_CODE = articlecode;
		
   
	-- If no row then insert
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.ARTICLE_LOOKUP_INC
		(
      			ARTICLE_CODE
			,ARTICLE_LABEL
      			,CATEGORY
      			,SALE_PRICE
      			,FAMILY_NAME
      			,FAMILY_CODE
			,OPERATION_TYPE
		)
		VALUES
		(
      			articlecode
			,:old.ARTICLE_LABEL
      			,:old.CATEGORY
      			,:old.SALE_PRICE
      			,:old.FAMILY_NAME
      			,:old.FAMILY_CODE
			,'DELETE'
		);
	-- Else Get operation type from ARTICLE_LOOKUP_INC
	ELSE
        	SELECT
         	 OPERATION_TYPE INTO operationtype
         	FROM
           	EMODE_INC.ARTICLE_LOOKUP_INC 
        	WHERE
          	ARTICLE_CODE = articlecode;
        
		-- If operation type 'INSERT'then delete lines
       	 	IF(operationtype='INSERT') THEN
            		DELETE FROM EMODE_INC.ARTICLE_LOOKUP_INC 
				WHERE ARTICLE_CODE = :old.ARTICLE_CODE;
		-- Else moficate lines data
        	ELSE   
           		UPDATE EMODE_INC.ARTICLE_LOOKUP_INC
           		SET OPERATION_TYPE = 'DELETE'
           	 	WHERE ARTICLE_CODE = articlecode;
        	END IF;
	END IF;

  
END ARTICLE_LOOKUP_TAD;
/
ALTER TRIGGER "EMODE"."ARTICLE_LOOKUP_TAD" ENABLE;
-- ARTICLE_COLOR_LOOKUP triggers
-- After insert
CREATE OR REPLACE TRIGGER "EMODE"."ARTICLE_COLOR_LOOKUP_TAI"
AFTER INSERT ON EMODE.ARTICLE_COLOR_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER;
	operationtype VARCHAR2(6);
	articlecode NUMBER(10);
  	colorcode NUMBER(10);
BEGIN
	-- If PK is null then initialize articlecode and colorcode to 0	
	IF(:new.ARTICLE_CODE IS NULL) THEN
		articlecode := 0;
	ELSE
		articlecode := :new.ARTICLE_CODE;
	END IF; 
  
    	IF(:new.COLOR_CODE IS NULL) THEN
		colorcode := 0;
	ELSE
		colorcode := :new.COLOR_CODE;
	END IF; 
  	-- Insert the number of rows existed in ARTICLE_COLOR_LOOKUP_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
	WHERE
		ARTICLE_CODE = articlecode
  	AND
   		COLOR_CODE = colorcode;
   	-- If no row then insert
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
		(
      			ARTICLE_CODE
      			,COLOR_CODE
			,ARTICLE_LABEL
      			,COLOR_LABEL
      			,CATEGORY
      			,SALE_PRICE
      			,FAMILY_NAME
      			,FAMILY_CODE
			,OPERATION_TYPE
		)
		VALUES
		(
      			articlecode
      			,colorcode
			,:new.ARTICLE_LABEL
      			,:new.COLOR_LABEL
      			,:new.CATEGORY
      			,:new.SALE_PRICE
      			,:new.FAMILY_NAME
      			,:new.FAMILY_CODE
			,'INSERT'
		);
	-- Else Get operation type from ARTICLE_COLOR_LOOKUP_INC
	ELSE
        	SELECT
         		OPERATION_TYPE INTO operationtype
         	FROM
         	  	EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
        	WHERE
          		ARTICLE_CODE = articlecode
        		AND
          		COLOR_CODE = colorcode;
       		--IF opration type is 'DELETE' THEN change it to 'UPDATE' and update other columns else update rows
    		IF(operationtype='DELETE') THEN
			UPDATE EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
			SET	
         			ARTICLE_CODE = articlecode
        			,COLOR_CODE = colorcode
        			,ARTICLE_LABEL = :new.ARTICLE_LABEL
        			,COLOR_LABEL = :new.COLOR_LABEL
        			,CATEGORY = :new.CATEGORY
        			,SALE_PRICE = :new.SALE_PRICE
        			,FAMILY_NAME = :new.FAMILY_NAME
        			,FAMILY_CODE = :new.FAMILY_CODE
				,OPERATION_TYPE = 'UPDATE'
			WHERE 
				ARTICLE_CODE = articlecode
      				AND
        			COLOR_CODE = colorcode;
		ELSE   
			UPDATE EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
			SET	
         			ARTICLE_CODE = articlecode
        			,COLOR_CODE = colorcode
        			,ARTICLE_LABEL = :new.ARTICLE_LABEL
        			,COLOR_LABEL = :new.COLOR_LABEL
        			,CATEGORY = :new.CATEGORY
        			,SALE_PRICE = :new.SALE_PRICE
        			,FAMILY_NAME = :new.FAMILY_NAME
        			,FAMILY_CODE = :new.FAMILY_CODE
				,OPERATION_TYPE = operationtype
			WHERE 
				ARTICLE_CODE = articlecode
      				AND
        			COLOR_CODE = colorcode;
		END IF;
	END IF;
END ARTICLE_COLOR_LOOKUP_TAI;
/
ALTER TRIGGER "EMODE"."ARTICLE_COLOR_LOOKUP_TAI" ENABLE;
-- After update
CREATE OR REPLACE TRIGGER "EMODE"."ARTICLE_COLOR_LOOKUP_TAU"
AFTER UPDATE ON EMODE.ARTICLE_COLOR_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER;
	operationtype VARCHAR2(6);
	articlecode NUMBER(10);
  	colorcode NUMBER(10);
  	rowsdetectedsf NUMBER(10);
BEGIN
	-- If PK is null then initialize articlecode and colorcode to 0
	IF(:new.ARTICLE_CODE IS NULL) THEN
		articlecode := 0;
	ELSE
		articlecode := :new.ARTICLE_CODE;
	END IF; 
  
    	IF(:new.COLOR_CODE IS NULL) THEN
		colorcode := 0;
	ELSE
		colorcode := :new.COLOR_CODE;
	END IF; 
  
	-- Insert the number of rows existed in ARTICLE_COLOR_LOOKUP_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
	WHERE
		ARTICLE_CODE = :old.ARTICLE_CODE
  		AND 
    		COLOR_CODE = :old.COLOR_CODE;
  
	-- Test PK modification
	IF(:old.ARTICLE_CODE <> articlecode OR :old.COLOR_CODE <> colorcode) THEN 
		-- Test existance of article in SHOP_FACTS 
		SELECT 
			COUNT(*) INTO rowsdetectedsf
		FROM 
			EMODE.SHOP_FACTS
		WHERE 
			ARTICLE_CODE = :old.ARTICLE_CODE;
		
		-- If exist then update
		IF (rowsdetectedsf > 0) THEN
			UPDATE EMODE.SHOP_FACTS 
			SET 
        			ARTICLE_CODE = :new.ARTICLE_CODE
        			,COLOR_CODE = :new.COLOR_CODE
			WHERE 
        			ARTICLE_CODE = :old.ARTICLE_CODE
      				AND
        			COLOR_CODE = :old.COLOR_CODE;      
   	 	END IF;  
    		-- Delete old existed lines in EMODE_INC
    		IF (rowsdetected > 0) THEN
    			DELETE FROM EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
    			WHERE ARTICLE_CODE = :old.ARTICLE_CODE
    			AND COLOR_CODE = :old.COLOR_CODE;  
    		END IF;
    
			-- insert to Delete old articles
			INSERT INTO EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
			(
        			ARTICLE_CODE
        			,COLOR_CODE
        			,ARTICLE_LABEL
        			,COLOR_LABEL
        			,CATEGORY
        			,SALE_PRICE
        			,FAMILY_NAME
        			,FAMILY_CODE
        			,OPERATION_TYPE
			)
			VALUES
			(
     	 			articlecode
      				,colorcode
				,:old.ARTICLE_LABEL
      				,:old.COLOR_LABEL
      				,:old.CATEGORY
      				,:old.SALE_PRICE
      				,:old.FAMILY_NAME
      				,:old.FAMILY_CODE
				,'DELETE'
			);
    
			-- Insert articles with new PK
			INSERT INTO EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
			(
        			ARTICLE_CODE
        			,COLOR_CODE
        			,ARTICLE_LABEL
        			,COLOR_LABEL
        			,CATEGORY
        			,SALE_PRICE
        			,FAMILY_NAME
        			,FAMILY_CODE
        			,OPERATION_TYPE
			)
			VALUES
			(
      				articlecode
      				,colorcode
				,:new.ARTICLE_LABEL
      				,:new.COLOR_LABEL
      				,:new.CATEGORY
      				,:new.SALE_PRICE
      				,:new.FAMILY_NAME
      				,:new.FAMILY_CODE
				,'INSERT'
		); 
	-- If no old PK then update other data
	ELSE 
		IF(rowsdetected=0) THEN
			INSERT INTO EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
			(
        			ARTICLE_CODE
        			,COLOR_CODE
        			,ARTICLE_LABEL
        			,COLOR_LABEL
        			,CATEGORY
        			,SALE_PRICE
        			,FAMILY_NAME
        			,FAMILY_CODE
        			,OPERATION_TYPE
			)
			VALUES
			(
        			articlecode
        			,colorcode
        			,:new.ARTICLE_LABEL
        			,:new.COLOR_LABEL
        			,:new.CATEGORY
        			,:new.SALE_PRICE
        			,:new.FAMILY_NAME
        			,:new.FAMILY_CODE
        			,'UPDATE'
			);
		ELSE
			SELECT
				OPERATION_TYPE INTO operationtype
			FROM
				EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
			WHERE
				ARTICLE_CODE = articlecode
      			AND
       				 COLOR_CODE = colorcode;  
        
			UPDATE 
				EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
			SET	
        			 ARTICLE_CODE = articlecode
        			,COLOR_CODE = colorcode
        			,ARTICLE_LABEL = :new.ARTICLE_LABEL
        			,COLOR_LABEL = :new.COLOR_LABEL
        			,CATEGORY = :new.CATEGORY
        			,SALE_PRICE = :new.SALE_PRICE
        			,FAMILY_NAME = :new.FAMILY_NAME
        			,FAMILY_CODE = :new.FAMILY_CODE
				,OPERATION_TYPE = operationtype
			WHERE 
				ARTICLE_CODE = articlecode
      			AND
        		COLOR_CODE = colorcode; 
		END IF; 
	END IF; 
END ARTICLE_COLOR_LOOKUP_TAU;
/
ALTER TRIGGER "EMODE"."ARTICLE_COLOR_LOOKUP_TAU" ENABLE;
-- After delete
CREATE OR REPLACE TRIGGER "EMODE"."ARTICLE_COLOR_LOOKUP_TAD" 
AFTER DELETE ON EMODE.ARTICLE_COLOR_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER(10);
	operationtype VARCHAR2(6);
	articlecode NUMBER(10);
  	colorcode NUMBER(10);
BEGIN
	-- If PK is null then initialize articlecode and colorcode to 0
	IF(:old.ARTICLE_CODE IS NULL) THEN
		articlecode := 0;
	ELSE
		articlecode := :old.ARTICLE_CODE;
	END IF; 
  
  	IF(:old.COLOR_CODE IS NULL) THEN
		colorcode := 0;
	ELSE
		colorcode := :old.COLOR_CODE;
	END IF; 
	
	-- Insert the number of rows existed in ARTICLE_COLOR_LOOKUP_INC that have the PK	
    SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.ARTICLE_COLOR_LOOKUP_INC 
	WHERE
		ARTICLE_CODE = articlecode
  	AND 
    		COLOR_CODE = colorcode;
		
   
	-- If no row then then insert
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
		(
      			ARTICLE_CODE
      			,COLOR_CODE
			,ARTICLE_LABEL
      			,COLOR_LABEL
      			,CATEGORY
      			,SALE_PRICE
      			,FAMILY_NAME
      			,FAMILY_CODE
			,OPERATION_TYPE
		)
		VALUES
		(
      			articlecode
      			,colorcode
			,:old.ARTICLE_LABEL
      			,:old.COLOR_LABEL
      			,:old.CATEGORY
      			,:old.SALE_PRICE
      			,:old.FAMILY_NAME
      			,:old.FAMILY_CODE
			,'DELETE'
		);
	ELSE
		-- Else Get operation type from ARTICLE_COLOR_LOOKUP_INC
        SELECT
          OPERATION_TYPE INTO operationtype
         FROM
           EMODE_INC.ARTICLE_COLOR_LOOKUP_INC 
        WHERE
          ARTICLE_CODE = articlecode
        AND 
          COLOR_CODE = colorcode;
        
		-- IF opration type 'INSERT' then delete the row else update the operation types's row to delete
        IF(operationtype='INSERT') THEN
            DELETE FROM EMODE_INC.ARTICLE_COLOR_LOOKUP_INC 
            WHERE ARTICLE_CODE = :old.ARTICLE_CODE
            AND COLOR_CODE = :old.COLOR_CODE;
        ELSE   
            UPDATE EMODE_INC.ARTICLE_COLOR_LOOKUP_INC
            SET OPERATION_TYPE = 'DELETE'
            WHERE ARTICLE_CODE = articlecode
            AND COLOR_CODE = :old.COLOR_CODE;
        END IF;
	END IF;

  
END ARTICLE_COLOR_LOOKUP_TAD;
/
ALTER TRIGGER "EMODE"."ARTICLE_COLOR_LOOKUP_TAD" ENABLE;
-- After insert
CREATE OR REPLACE TRIGGER "EMODE"."CALENDAR_YEAR_LOOKUP_TAI" 
AFTER INSERT ON EMODE.CALENDAR_YEAR_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER;
	operationtype VARCHAR2(6);
	weekkey NUMBER(10);
BEGIN
	-- If PK is null then initialize weekkey to 0
	IF(:new.WEEK_KEY IS NULL) THEN
		weekkey := 0;
	ELSE
		weekkey := :new.WEEK_KEY;
	END IF; 
        -- Insert the number of rows existed in CALENDAR_YEAR_LOOKUP_INC that have the PK
    	SELECT
		COUNT(*) INTO rowsdetected
	FROM
		EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
	WHERE
		WEEK_KEY = weekkey;
   	-- If no row then insert
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
			(
      			WEEK_KEY
      			,WEEK_IN_YEAR
      			,YEAR
      			,FISCAL_PERIOD
      			,YEAR_WEEK
      			,QUARTER
      			,MONTH_NAME
      			,MONTH
      			,HOLIDAY_FLAG
			,OPERATION_TYPE
		)
		VALUES
		(
      		weekkey
      		,:new.WEEK_IN_YEAR
      		,:new.YEAR
      		,:new.FISCAL_PERIOD
      		,:new.YEAR_WEEK
      		,:new.QUARTER
      		,:new.MONTH_NAME
      		,:new.MONTH
      		,:new.HOLIDAY_FLAG
		,'INSERT'
		);
	-- Else Get operation type from CALENDAR_YEAR_LOOKUP_INC
	ELSE
        	SELECT
         		OPERATION_TYPE INTO operationtype
         	FROM
           		EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
        	WHERE
          		WEEK_KEY = weekkey;
        	--IF opration type is 'DELETE' THEN change it to 'UPDATE' and update other columns else update rows
        	IF(operationtype='DELETE') THEN
			UPDATE EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
			SET	
        			WEEK_KEY = weekkey
       				,WEEK_IN_YEAR = :new.WEEK_IN_YEAR
       				,YEAR = :new.YEAR
      				,FISCAL_PERIOD = :new.FISCAL_PERIOD
       				,YEAR_WEEK = :new.YEAR_WEEK
       				,QUARTER = :new.QUARTER
       				,MONTH_NAME = :new.MONTH_NAME
       				,MONTH = :new.MONTH
       				,HOLIDAY_FLAG = :new.HOLIDAY_FLAG
       				,OPERATION_TYPE = 'UPDATE'
			WHERE 
				WEEK_KEY = weekkey;
		ELSE   
			UPDATE EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
			SET	
        			WEEK_KEY = weekkey
       				,WEEK_IN_YEAR = :new.WEEK_IN_YEAR
       				,YEAR = :new.YEAR
      				,FISCAL_PERIOD = :new.FISCAL_PERIOD
       				,YEAR_WEEK = :new.YEAR_WEEK
       				,QUARTER = :new.QUARTER
       				,MONTH_NAME = :new.MONTH_NAME
       				,MONTH = :new.MONTH
       				,HOLIDAY_FLAG = :new.HOLIDAY_FLAG
       				,OPERATION_TYPE = operationtype
			WHERE 
          			WEEK_KEY = weekkey;
		END IF;
	END IF;
END CALENDAR_YEAR_LOOKUP_TAI;
/
ALTER TRIGGER "EMODE"."CALENDAR_YEAR_LOOKUP_TAI" ENABLE;
-- After update
CREATE OR REPLACE TRIGGER "EMODE"."CALENDAR_YEAR_LOOKUP_TAU" 
AFTER UPDATE ON EMODE.CALENDAR_YEAR_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER;
	operationtype VARCHAR2(6);
	weekkey NUMBER(10);
  	rowsdetectedSF NUMBER(10);
BEGIN
	-- If PK is null then initialize weekkey to 0
	IF(:new.WEEK_KEY IS NULL) THEN
		weekkey := 0;
	ELSE
		weekkey := :new.WEEK_KEY;
	END IF;
  
	-- Insert the number of rows existed in CALENDAR_YEAR_LOOKUP_INC that have the PK
    	SELECT
      		COUNT(*) INTO rowsdetected
    	FROM
      		EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
   	WHERE
      		WEEK_KEY = :old.WEEK_KEY;
  
	-- Test PK modification
	IF(:old.WEEK_KEY <> weekkey) THEN 
		-- Test existance of WEEK_KEY in SHOP_FACTS 
		SELECT 
			COUNT(*) INTO rowsdetectedSF
		FROM 
			EMODE.SHOP_FACTS
		WHERE 
			WEEK_KEY = :old.WEEK_KEY;
		
		-- If exist then update
		IF (rowsdetectedSF > 0) THEN
			UPDATE EMODE.SHOP_FACTS 
			SET WEEK_KEY = :new.WEEK_KEY
			WHERE WEEK_KEY = :old.WEEK_KEY;
     		END IF; 
      
    		-- Delete old existed lines in EMODE_INC
    		IF (rowsdetected > 0) THEN
    			DELETE FROM EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
    			WHERE WEEK_KEY = :old.WEEK_KEY;
    		END IF;
    
		-- insert to Delete old lines
		INSERT INTO EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
			(
        		WEEK_KEY
        		,WEEK_IN_YEAR
        		,YEAR
        		,FISCAL_PERIOD
        		,YEAR_WEEK
        		,QUARTER
        		,MONTH_NAME
        		,MONTH
        		,HOLIDAY_FLAG
        		,OPERATION_TYPE
			)
			VALUES
			(
      			weekkey
      			,:old.WEEK_IN_YEAR
      			,:old.YEAR
      			,:old.FISCAL_PERIOD
      			,:old.YEAR_WEEK
      			,:old.QUARTER
      			,:old.MONTH_NAME
      			,:old.MONTH
      			,:old.HOLIDAY_FLAG
			,'DELETE'
			);
    
			-- Insert with new PK
		INSERT INTO EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
			(
        		WEEK_KEY
        		,WEEK_IN_YEAR
        		,YEAR
        		,FISCAL_PERIOD
        		,YEAR_WEEK
        		,QUARTER
        		,MONTH_NAME
        		,MONTH
        		,HOLIDAY_FLAG
        		,OPERATION_TYPE
			)
			VALUES
			(
      			weekkey
      			,:new.WEEK_IN_YEAR
      			,:new.YEAR
      			,:new.FISCAL_PERIOD
      			,:new.YEAR_WEEK
      			,:new.QUARTER
      			,:new.MONTH_NAME
      			,:new.MONTH
      			,:new.HOLIDAY_FLAG
			,'INSERT'
		); 
	-- If no old PK then update other data	
	ELSE
		IF(rowsdetected=0) THEN
			INSERT INTO EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
			(
        		WEEK_KEY
        		,WEEK_IN_YEAR
        		,YEAR
        		,FISCAL_PERIOD
        		,YEAR_WEEK
        		,QUARTER
        		,MONTH_NAME
        		,MONTH
        		,HOLIDAY_FLAG
        		,OPERATION_TYPE
			)
			VALUES
			(
        		weekkey
        		,:new.WEEK_IN_YEAR
        		,:new.YEAR
        		,:new.FISCAL_PERIOD
        		,:new.YEAR_WEEK
        		,:new.QUARTER
        		,:new.MONTH_NAME
        		,:new.MONTH
        		,:new.HOLIDAY_FLAG
        		,'UPDATE'
			);
		ELSE
			SELECT
				OPERATION_TYPE INTO operationtype
			FROM
				EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
			WHERE
				WEEK_KEY = weekkey;
        
			UPDATE 
				EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
			SET	
        			WEEK_KEY = weekkey
       				,WEEK_IN_YEAR = :new.WEEK_IN_YEAR
       				,YEAR = :new.YEAR
      				,FISCAL_PERIOD = :new.FISCAL_PERIOD
       				,YEAR_WEEK = :new.YEAR_WEEK
       				,QUARTER = :new.QUARTER
       				,MONTH_NAME = :new.MONTH_NAME
       				,MONTH = :new.MONTH
       				,HOLIDAY_FLAG = :new.HOLIDAY_FLAG
       				,OPERATION_TYPE = operationtype
			WHERE 
				WEEK_KEY = weekkey;
		END IF; 
	END IF; 
END CALENDAR_YEAR_LOOKUP_TAU;
/
ALTER TRIGGER "EMODE"."CALENDAR_YEAR_LOOKUP_TAU" ENABLE;
-- After delete
CREATE OR REPLACE TRIGGER "EMODE"."CALENDAR_YEAR_LOOKUP_TAD" 
AFTER DELETE ON EMODE.CALENDAR_YEAR_LOOKUP
FOR EACH ROW
DECLARE
	rowsdetected NUMBER(10);
	operationtype VARCHAR2(6);
	weekkey NUMBER(10);
BEGIN
	-- If PK is null then initialize weekkey to 0
	IF(:old.WEEK_KEY IS NULL) THEN
		weekkey := 0;
	ELSE
		weekkey := :old.WEEK_KEY;
	END IF; 
	
	-- Insert the number of rows existed in CALENDAR_YEAR_LOOKUP_INC that have the PK
    	SELECT
      		COUNT(*) INTO rowsdetected
    	FROM
      		EMODE_INC.CALENDAR_YEAR_LOOKUP_INC 
    	WHERE
    		WEEK_KEY = weekkey;
		
   
	-- If no row then insert
	IF(rowsdetected=0) THEN
		INSERT INTO EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
		(
      			WEEK_KEY
      			,WEEK_IN_YEAR
      			,YEAR
      			,FISCAL_PERIOD
      			,YEAR_WEEK
      			,QUARTER
      			,MONTH_NAME
      			,MONTH
      			,HOLIDAY_FLAG
			,OPERATION_TYPE
		)
		VALUES
		(
	      		weekkey
      			,:old.WEEK_IN_YEAR
      			,:old.YEAR
      			,:old.FISCAL_PERIOD
      			,:old.YEAR_WEEK
      			,:old.QUARTER
      			,:old.MONTH_NAME
      			,:old.MONTH
      			,:old.HOLIDAY_FLAG
			,'DELETE'
		);
	-- Else Get operation type from CALENDAR_YEAR_LOOKUP_INC	
	ELSE		
        	SELECT
          		OPERATION_TYPE INTO operationtype
         	FROM
           		EMODE_INC.CALENDAR_YEAR_LOOKUP_INC 
        	WHERE
          		WEEK_KEY = weekkey;
        
		-- If operation type 'INSERT'then delete lines
        	IF(operationtype='INSERT') THEN
            		DELETE FROM EMODE_INC.CALENDAR_YEAR_LOOKUP_INC 
			WHERE WEEK_KEY = :old.WEEK_KEY;
		-- Else moficate lines data
        	ELSE   
            	UPDATE EMODE_INC.CALENDAR_YEAR_LOOKUP_INC
            	SET OPERATION_TYPE = 'DELETE'
            	WHERE WEEK_KEY = weekkey;
        	END IF;
	END IF;

  
END CALENDAR_YEAR_LOOKUP_TAD;
/
ALTER TRIGGER "EMODE"."CALENDAR_YEAR_LOOKUP_TAD" ENABLE;
