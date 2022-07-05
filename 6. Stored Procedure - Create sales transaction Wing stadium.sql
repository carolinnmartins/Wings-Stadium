-- CREATE PROCEDURE TO SALES --
USE clm_wings_stadium;

/* This procedure will insert values on ticket_sales table and update the ticket_status and sale_id field from 
tickets table after we sell a ticket. 
*/

DELIMITER $$

CREATE PROCEDURE sales_transaction (
IN in_client_id INT,
IN in_partner_id INT,
IN in_ticket_id INT)

BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        END;
        COMMIT;
START TRANSACTION; 

SET @sales_date := CURRENT_DATE();
SELECT @sales_date;

/* This function it's used to calculate the total value a client will pay. It's the sum of ticket_price (tickets table) + processing_fee (partners table) 
It depends on ticket_id (each ticket has a ticket_price associated) and the partner_id.
*/  
SET  @total_amount := (select function_totalamount(in_ticket_id, in_partner_id));

INSERT INTO ticket_sales (client_id,sales_date,partner_id,total_amount)
VALUES (in_client_id,@sales_date,in_partner_id,@total_amount);

SET @sales_id := LAST_INSERT_ID();

-- After a sale, the tickets table will be updated at ticket_status and sale_id. --

UPDATE tickets 
SET sale_id = @sales_id
WHERE ticket_id = in_ticket_id AND ticket_status = 'To sell';

-- To guarantee that if occurs a sale but the tickets table isn't updated with that info, it does a rollback. -- 
SET @nr_of_tickets_sold := (SELECT COUNT(sale_id) FROM tickets
WHERE sale_id = @sales_id);
SELECT @sales_id;

IF @nr_of_tickets_sold = 0 THEN 
	ROLLBACK;
END IF;

COMMIT;
END $$

DELIMITER ;