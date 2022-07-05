CREATE DATABASE CLM_Wings_Stadium;

USE CLM_Wings_Stadium;

CREATE TABLE `clients` (
  `client_id` int PRIMARY KEY AUTO_INCREMENT,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `birth_date` date NOT NULL,
  `gender` VARCHAR(30),
  `email` varchar(200) UNIQUE,
  `phone_number` varchar(50),
  `country_of_residence` varchar(5) NOT NULL
);

CREATE TABLE `country` (
  `iso_code` varchar(5) PRIMARY KEY,
  `country_name` varchar(248) NOT NULL
);

CREATE TABLE `tickets` (
  `ticket_id` int PRIMARY KEY AUTO_INCREMENT,
  `event_id` int NOT NULL,
  `ticket_status` varchar(30) DEFAULT 'To sell',
  `ticket_price` decimal(5,2) NOT NULL,
  `seat_id` int NOT NULL,
  `sale_id` int
);

CREATE TABLE `ticket_sales` (
  `sales_id` int PRIMARY KEY AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `sales_date` datetime,
  `partner_id` int,
  `total_amount` decimal(10,2)
);

CREATE TABLE `partners` (
  `partner_id` int PRIMARY KEY,
  `partner_name` varchar(30),
  `p_website` varchar(100),
  `processing_fee` decimal(3,2)
);

CREATE TABLE `seats` (
  `seat_id` int PRIMARY KEY AUTO_INCREMENT,
  `seat_row` int NOT NULL,
  `sector_id` int NOT NULL,
  `seat_nr` int NOT NULL
);

CREATE TABLE `sectors` (
  `sector_id` int PRIMARY KEY AUTO_INCREMENT,
  `sector_name` varchar(5),
  `seat_nr` int,
  `category_id` int
);

CREATE TABLE `category` (
  `category_id` int PRIMARY KEY,
  `category_name` varchar(30)
);

CREATE TABLE `artist` (
  `artist_id` int PRIMARY KEY AUTO_INCREMENT,
  `artist_name` varchar(100) NOT NULL,
  `artist_income` decimal(10,2)
);

CREATE TABLE `artist_event` (
  `event_id` int,
  `artist_id` int,
  PRIMARY KEY (event_id,artist_id)
);

CREATE TABLE `events` (
  `event_id` int PRIMARY KEY AUTO_INCREMENT,
  `description` varchar(255),
  `start_time` datetime,
  `end_time` datetime,
  `status` varchar(40) DEFAULT 'scheduled',
  `replaced_by` int DEFAULT '0'
);

ALTER TABLE `clients` ADD FOREIGN KEY (`country_of_residence`) REFERENCES `country` (`iso_code`);

ALTER TABLE `tickets` ADD FOREIGN KEY (`seat_id`) REFERENCES `seats` (`seat_id`);

ALTER TABLE `tickets` ADD FOREIGN KEY (`sale_id`) REFERENCES `ticket_sales` (`sales_id`);

ALTER TABLE `tickets` ADD FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`);

ALTER TABLE `ticket_sales` ADD FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`);

ALTER TABLE `ticket_sales` ADD FOREIGN KEY (`partner_id`) REFERENCES `partners` (`partner_id`);

ALTER TABLE `seats` ADD FOREIGN KEY (`sector_id`) REFERENCES `sectors` (`sector_id`);

ALTER TABLE `sectors` ADD FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`);

ALTER TABLE `artist` ADD CONSTRAINT UC_artist_name UNIQUE (artist_name);

ALTER TABLE `artist_event` ADD FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`);

ALTER TABLE `artist_event` ADD FOREIGN KEY (`artist_id`) REFERENCES `artist` (`artist_id`);
