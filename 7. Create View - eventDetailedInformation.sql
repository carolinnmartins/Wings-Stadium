USE clm_wings_stadium;

CREATE VIEW eventDetailedInformation
AS
SELECT 
    t.event_id,
    evt.description AS event_description,
    cat.category_name,
    COUNT(*) AS nr_seats,
    t.ticket_status,
    t.ticket_price,
    SUM(t.ticket_price) AS sales_forecast
FROM
    tickets t
        JOIN
    seats st ON st.seat_id = t.seat_id
        JOIN
    sectors sect ON sect.sector_id = st.sector_id
        JOIN
    category cat ON cat.category_id = sect.category_id
        JOIN
    events evt ON evt.event_id = t.event_id
GROUP BY t.event_id , evt.description , cat.category_name, t.ticket_status
ORDER BY t.event_id , cat.category_name;
