-- CREATE DATABASE hotel_db;
USE hotel_db;
SELECT * FROM hotel_bookings LIMIT 10;

-- 1. What is the total number of reservations in the dataset? 

SELECT COUNT(*) AS total_reservations FROM hotel_bookings;


-- 2. Which meal plan is the most popular among guests?

SELECT type_of_meal_plan, COUNT(*) AS total_bookings FROM hotel_bookings
GROUP BY type_of_meal_plan
ORDER BY total_bookings DESC
LIMIT 1;


-- 3. What is the average price per room for reservations involving children?

SELECT AVG(avg_price_per_room) AS avg_price_with_children FROM hotel_bookings
WHERE no_of_children > 0; 


-- How many reservations were made for the year 20XX (replace XX with the  desired year)?

SELECT DISTINCT arrival_date FROM hotel_bookings ORDER BY arrival_date 
LIMIT 10;

SELECT COUNT(*) AS reservations_2018 FROM hotel_bookings
WHERE YEAR(STR_TO_DATE(arrival_date, '%d-%m-%Y')) = 2018;


-- 5. What is the most commonly booked room type?

SELECT room_type_reserved, COUNT(*) AS total_bookings FROM hotel_bookings
GROUP BY room_type_reserved
ORDER BY total_bookings DESC
LIMIT 1;


-- 6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?

SELECT COUNT(*) AS weekend_reservations FROM hotel_bookings
WHERE no_of_weekend_nights > 0;


-- 7. What is the highest and lowest lead time for reservations?

SELECT MAX(lead_time) AS highest_lead_time,
  MIN(lead_time) AS lowest_lead_time
FROM hotel_bookings;


-- 8. What is the most common market segment type for reservations? 

SELECT market_segment_type, COUNT(*) AS total_reservations FROM hotel_bookings
GROUP BY market_segment_type
ORDER BY total_reservations DESC
LIMIT 1;


-- 9. How many reservations have a booking status of "Confirmed"? 

SELECT COUNT(*) AS confirmed_reservations FROM hotel_bookings
WHERE booking_status = 'Confirmed';


-- 10. What is the total number of adults and children across all reservations? 

SELECT SUM(no_of_adults) AS total_adults,
  SUM(no_of_children) AS total_children
FROM hotel_bookings;

-- 11. Rank room types by average price within each market segment. 

SELECT market_segment_type, room_type_reserved,
  AVG(avg_price_per_room) AS avg_price,
  RANK() OVER (PARTITION BY market_segment_type ORDER BY AVG(avg_price_per_room) DESC) AS price_rank
FROM hotel_bookings
GROUP BY market_segment_type, room_type_reserved;


-- 12. Find the top 2 most frequently booked room types per market segment. 

SELECT *
FROM (
    SELECT market_segment_type, room_type_reserved, COUNT(*) AS booking_count,
      RANK() OVER (PARTITION BY market_segment_type ORDER BY COUNT(*) DESC) AS room_rank
    FROM hotel_bookings
    GROUP BY market_segment_type, room_type_reserved
) ranked_rooms
WHERE room_rank <= 2;


-- 13. What is the average number of nights (both weekend and weekday) spent by guests for each room type? 

SELECT room_type_reserved, AVG(no_of_weekend_nights + no_of_week_nights) AS avg_total_nights
FROM hotel_bookings
GROUP BY room_type_reserved;


-- 14. For reservations involving children, what is the most common room type, and what is the average price for that room type? 

SELECT room_type_reserved, COUNT(*) AS booking_count, AVG(avg_price_per_room) AS avg_price
FROM hotel_bookings WHERE no_of_children > 0
GROUP BY room_type_reserved
ORDER BY booking_count DESC
LIMIT 1;


-- 15. Find the market segment type that generates the highest average price per room.

SELECT market_segment_type, AVG(avg_price_per_room) AS avg_price
FROM hotel_bookings
GROUP BY market_segment_type
ORDER BY avg_price DESC
LIMIT 1;
