USE clm_wings_stadium;

-- CREATE STORED PROCEDURE TO INSERT EVENTS ON EVENTS TABLE --
/* This stored procedure it's related with 3 different tables (events, artist_event,tickets). 
First I looked to insert data into events table and then I set variables to create a relationship between the 3 tables. 
After we create the events, through this stored procedure, we immediately create tickets associated with it. */

DROP PROCEDURE create_event;

DELIMITER $$

CREATE PROCEDURE create_event(
  IN in_description VARCHAR(255), 
  IN in_start_time DATETIME, 
  IN in_end_time DATETIME,
  IN in_artist_name VARCHAR(100),
  IN in_base_price DECIMAL(5,2))
BEGIN
-- I created a transaction and rollback where to guarantee that all the inserts were performed, if there was any error, wouldn't happen the insert. -- 
DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        END;
COMMIT;
START TRANSACTION; 

-- insert into events table --
  INSERT INTO events (description,start_time,end_time) 
  VALUES(in_description,in_start_time,in_end_time);
    SET @event_id := LAST_INSERT_ID();
SELECT @event_id;

-- set variable artist_id to relate table events with table artist_event --
    SET @artist_id := (SELECT a.artist_id FROM artist a WHERE a.artist_name = in_artist_name);
    SELECT @artist_id;

-- insert into artist_event table the 2 variables created -- 
    INSERT INTO artist_event (event_id,artist_id)
    VALUES (@event_id,@artist_id);
    
-- set variable ticket_price to insert into tickets table -- 
    SET @ticket_price := (SELECT t.ticket_price FROM tickets t WHERE ticket_price = in_base_price);
    SELECT s.seat_id, @event_id, @ticket_price FROM seats s;
    
/* As I wanted to have different ticket prices for each event and each category, I created a case statement to establish this. 
This case statement uses the parameter in_base_price and multiplies it for the numbers that I chose. */

    INSERT INTO tickets (event_id,ticket_price,seat_id)
	SELECT  @event_id, 
		CASE 
		WHEN st.category_id = 1 THEN  in_base_price*1
		WHEN st.category_id = 2 THEN  in_base_price*1.6
		WHEN st.category_id = 3 THEN  in_base_price*2.4
		ELSE '-1'
		END AS ticket_price, s.seat_id  FROM seats s
    JOIN sectors st ON st.sector_id = s.sector_id;
    
COMMIT;
END $$

DELIMITER ;