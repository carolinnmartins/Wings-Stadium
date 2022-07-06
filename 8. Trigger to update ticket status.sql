-- Create trigger to update ticket status after a sale or resale -- 

USE clm_wings_stadium;

DROP TRIGGER ticket_status_update;

DELIMITER $$ 

CREATE TRIGGER ticket_status_update
BEFORE UPDATE ON tickets
FOR EACH ROW
BEGIN

IF new.sale_id IS NOT NULL THEN 
	SET new.ticket_status = 'Sold';
END IF;

IF new.sale_id IS NULL AND old.sale_id IS NOT NULL THEN 
	SET new.ticket_status = 'Resale ticket';
END IF;

END $$
 
DELIMITER ;