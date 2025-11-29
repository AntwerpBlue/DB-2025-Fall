CREATE TABLE `Facility`  (
  `facility_id` int NOT NULL,
  `facility_name` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `contact_person` varchar(255) NOT NULL,
  `contact_phone` varchar(255) NOT NULL,
  `max_capacity` int NOT NULL,
  `description` varchar(255) NULL,
  PRIMARY KEY (`facility_id`)
);

CREATE TABLE `Order`  (
  `order_id` int NOT NULL,
  `pet_id` int NOT NULL,
  `facility_id` int NOT NULL,
  `service_id` int NOT NULL,
  `start_date` datetime NULL,
  `end_date` datetime NULL,
  `total_amount` double NULL,
  `status` varchar(255) NOT NULL,
  `created_time` datetime NOT NULL,
  PRIMARY KEY (`order_id`)
);

CREATE TABLE `Pet`  (
  `pet_id` int NOT NULL,
  `owner_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `species` varchar(255) NOT NULL,
  `breed` varchar(255) NULL,
  `age` int NULL,
  `weight` double NULL,
  `special_notes` varchar(255) NULL,
  PRIMARY KEY (`pet_id`)
);

CREATE TABLE `PetOwner`  (
  `own_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  `email` varchar(255) NULL,
  `address` varchar(255) NULL,
  PRIMARY KEY (`own_id`)
);

CREATE TABLE `Service`  (
  `service_id` int NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `description` varchar(255) NULL,
  `standard_price` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`service_id`)
);

CREATE TABLE `Transaction`  (
  `transaction_id` int NOT NULL,
  `order_id` int NOT NULL,
  `service_date` datetime NOT NULL,
  `actual_price` decimal(10, 2) NOT NULL,
  `notes` varchar(255) NULL,
  PRIMARY KEY (`transaction_id`)
);

ALTER TABLE `Order` ADD CONSTRAINT `book` FOREIGN KEY (`service_id`) REFERENCES `Service` (`service_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `Order` ADD CONSTRAINT `place` FOREIGN KEY (`pet_id`) REFERENCES `Pet` (`pet_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `Order` ADD CONSTRAINT `accept` FOREIGN KEY (`facility_id`) REFERENCES `Facility` (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `Pet` ADD CONSTRAINT `own` FOREIGN KEY (`owner_id`) REFERENCES `PetOwner` (`own_id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `Transaction` ADD CONSTRAINT `generate` FOREIGN KEY (`order_id`) REFERENCES `Order` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE;

