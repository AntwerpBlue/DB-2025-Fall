/*
 Navicat Premium Dump SQL

 Source Server         : myconn
 Source Server Type    : MySQL
 Source Server Version : 80300 (8.3.0)
 Source Host           : localhost:3306
 Source Schema         : pet_boarding

 Target Server Type    : MySQL
 Target Server Version : 80300 (8.3.0)
 File Encoding         : 65001

 Date: 30/11/2025 20:08:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for capacityalert
-- ----------------------------
DROP TABLE IF EXISTS `capacityalert`;
CREATE TABLE `capacityalert`  (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `facility_id` int NOT NULL,
  `alert_date` date NOT NULL,
  `current_bookings` int NOT NULL,
  `max_capacity` int NOT NULL,
  `alert_level` enum('warning','critical') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `alert_message` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `is_notified` tinyint(1) NULL DEFAULT 0,
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`alert_id`) USING BTREE,
  INDEX `fk_capacityalert_facility`(`facility_id` ASC) USING BTREE,
  CONSTRAINT `fk_capacityalert_facility` FOREIGN KEY (`facility_id`) REFERENCES `facility` (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for facility
-- ----------------------------
DROP TABLE IF EXISTS `facility`;
CREATE TABLE `facility`  (
  `facility_id` int NOT NULL AUTO_INCREMENT,
  `facility_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `contact_person` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `contact_phone` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `max_capacity` int NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `operating_hours` json NULL,
  PRIMARY KEY (`facility_id`) USING BTREE,
  INDEX `idx_facility_contact`(`contact_phone` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for healthrecord
-- ----------------------------
DROP TABLE IF EXISTS `healthrecord`;
CREATE TABLE `healthrecord`  (
  `record_id` int NOT NULL AUTO_INCREMENT,
  `pet_id` int NOT NULL,
  `record_date` date NOT NULL,
  `record_type` enum('vaccination','medical','allergy','routine_check','surgery') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `veterinarian` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `clinic_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `next_due_date` date NULL DEFAULT NULL,
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `idx_pet_date`(`pet_id` ASC, `record_date` DESC) USING BTREE,
  INDEX `idx_due_date`(`next_due_date` ASC) USING BTREE,
  CONSTRAINT `fk_healthrecord_pet` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`pet_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for medicationrecord
-- ----------------------------
DROP TABLE IF EXISTS `medicationrecord`;
CREATE TABLE `medicationrecord`  (
  `medication_id` int NOT NULL AUTO_INCREMENT,
  `record_id` int NOT NULL,
  `medication_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `dosage` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `frequency` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `duration_days` int NULL DEFAULT NULL,
  `purpose` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  PRIMARY KEY (`medication_id`) USING BTREE,
  INDEX `fk_medicationrecord_healthrecord`(`record_id` ASC) USING BTREE,
  CONSTRAINT `fk_medicationrecord_healthrecord` FOREIGN KEY (`record_id`) REFERENCES `healthrecord` (`record_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for membership
-- ----------------------------
DROP TABLE IF EXISTS `membership`;
CREATE TABLE `membership`  (
  `membership_id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `tier_id` int NOT NULL DEFAULT 1,
  `current_points` int NULL DEFAULT 0,
  `total_points_earned` int NULL DEFAULT 0,
  `join_date` date NOT NULL,
  `expiry_date` date NULL DEFAULT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`membership_id`) USING BTREE,
  UNIQUE INDEX `unique_owner`(`owner_id` ASC) USING BTREE,
  INDEX `fk_membership_tier`(`tier_id` ASC) USING BTREE,
  CONSTRAINT `fk_membership_owner` FOREIGN KEY (`owner_id`) REFERENCES `petowner` (`owner_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_membership_tier` FOREIGN KEY (`tier_id`) REFERENCES `membershiptier` (`tier_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for membershiptier
-- ----------------------------
DROP TABLE IF EXISTS `membershiptier`;
CREATE TABLE `membershiptier`  (
  `tier_id` int NOT NULL AUTO_INCREMENT,
  `tier_name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `min_points` int NOT NULL,
  `discount_rate` decimal(3, 2) NULL DEFAULT 1.00,
  `benefits_description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  PRIMARY KEY (`tier_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `pet_id` int NOT NULL,
  `facility_id` int NOT NULL,
  `service_id` int NOT NULL,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `total_amount` decimal(10, 2) NULL DEFAULT NULL,
  `promotion_id` int NULL DEFAULT NULL,
  `points_earned` int NULL DEFAULT 0,
  `points_redeemed` int NULL DEFAULT 0,
  `status` enum('pending','confirmed','in_progress','completed','cancelled') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'pending',
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`) USING BTREE,
  INDEX `fk_order_promotion`(`promotion_id` ASC) USING BTREE,
  INDEX `fk_order_service`(`service_id` ASC) USING BTREE,
  INDEX `fk_order_pet`(`pet_id` ASC) USING BTREE,
  INDEX `fk_order_facility`(`facility_id` ASC) USING BTREE,
  INDEX `idx_order_dates`(`start_date` ASC, `end_date` ASC) USING BTREE,
  INDEX `idx_order_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_order_facility` FOREIGN KEY (`facility_id`) REFERENCES `facility` (`facility_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_pet` FOREIGN KEY (`pet_id`) REFERENCES `pet` (`pet_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_promotion` FOREIGN KEY (`promotion_id`) REFERENCES `promotion` (`promotion_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_order_service` FOREIGN KEY (`service_id`) REFERENCES `service` (`service_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pet
-- ----------------------------
DROP TABLE IF EXISTS `pet`;
CREATE TABLE `pet`  (
  `pet_id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `species` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `breed` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `age` int NULL DEFAULT NULL,
  `weight` decimal(5, 2) NULL DEFAULT NULL,
  `special_notes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`pet_id`) USING BTREE,
  INDEX `fk_pet_owner`(`owner_id` ASC) USING BTREE,
  CONSTRAINT `fk_pet_owner` FOREIGN KEY (`owner_id`) REFERENCES `petowner` (`owner_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for petowner
-- ----------------------------
DROP TABLE IF EXISTS `petowner`;
CREATE TABLE `petowner`  (
  `owner_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `phone_number` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`owner_id`) USING BTREE,
  INDEX `idx_owner_phone`(`phone_number` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for pointtransaction
-- ----------------------------
DROP TABLE IF EXISTS `pointtransaction`;
CREATE TABLE `pointtransaction`  (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `membership_id` int NOT NULL,
  `order_id` int NULL DEFAULT NULL,
  `points_change` int NOT NULL,
  `transaction_type` enum('earn','redeem','expire','adjust') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `balance_after` int NOT NULL,
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`) USING BTREE,
  INDEX `fk_pointtransaction_membership`(`membership_id` ASC) USING BTREE,
  INDEX `fk_pointtransaction_order`(`order_id` ASC) USING BTREE,
  CONSTRAINT `fk_pointtransaction_membership` FOREIGN KEY (`membership_id`) REFERENCES `membership` (`membership_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pointtransaction_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for promotion
-- ----------------------------
DROP TABLE IF EXISTS `promotion`;
CREATE TABLE `promotion`  (
  `promotion_id` int NOT NULL AUTO_INCREMENT,
  `promotion_name` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `promotion_type` enum('stay_n_free','points_multiplier','seasonal_discount') CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `config` json NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`promotion_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for service
-- ----------------------------
DROP TABLE IF EXISTS `service`;
CREATE TABLE `service`  (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `service_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `standard_price` decimal(10, 2) NOT NULL,
  PRIMARY KEY (`service_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for transaction
-- ----------------------------
DROP TABLE IF EXISTS `transaction`;
CREATE TABLE `transaction`  (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `service_date` date NOT NULL,
  `actual_price` decimal(10, 2) NOT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`) USING BTREE,
  INDEX `fk_transaction_order`(`order_id` ASC) USING BTREE,
  CONSTRAINT `fk_transaction_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for vaccinationrecord
-- ----------------------------
DROP TABLE IF EXISTS `vaccinationrecord`;
CREATE TABLE `vaccinationrecord`  (
  `vaccination_id` int NOT NULL AUTO_INCREMENT,
  `record_id` int NOT NULL,
  `vaccine_type` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `vaccine_brand` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `batch_number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `dosage` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `is_booster` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`vaccination_id`) USING BTREE,
  INDEX `fk_vaccinationrecord_healthrecord`(`record_id` ASC) USING BTREE,
  CONSTRAINT `fk_vaccinationrecord_healthrecord` FOREIGN KEY (`record_id`) REFERENCES `healthrecord` (`record_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- View structure for facilitydailycapacity
-- ----------------------------
DROP VIEW IF EXISTS `facilitydailycapacity`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `facilitydailycapacity` AS select `f`.`facility_id` AS `facility_id`,`f`.`facility_name` AS `facility_name`,`f`.`max_capacity` AS `max_capacity`,`cal`.`date` AS `check_date`,count(`o`.`order_id`) AS `current_bookings`,(`f`.`max_capacity` - count(`o`.`order_id`)) AS `available_slots`,(case when (count(`o`.`order_id`) >= `f`.`max_capacity`) then 'full' when (count(`o`.`order_id`) >= (`f`.`max_capacity` * 0.8)) then 'limited' else 'available' end) AS `capacity_status` from ((`facility` `f` join (select (curdate() + interval ((`a`.`a` + (10 * `b`.`a`)) + (100 * `c`.`a`)) day) AS `date` from (((select 0 AS `a` union select 1 AS `1` union select 2 AS `2` union select 3 AS `3` union select 4 AS `4` union select 5 AS `5` union select 6 AS `6` union select 7 AS `7` union select 8 AS `8` union select 9 AS `9`) `a` join (select 0 AS `a` union select 1 AS `1` union select 2 AS `2` union select 3 AS `3` union select 4 AS `4` union select 5 AS `5` union select 6 AS `6` union select 7 AS `7` union select 8 AS `8` union select 9 AS `9`) `b`) join (select 0 AS `a` union select 1 AS `1` union select 2 AS `2` union select 3 AS `3` union select 4 AS `4` union select 5 AS `5` union select 6 AS `6` union select 7 AS `7` union select 8 AS `8` union select 9 AS `9`) `c`)) `cal`) left join `order` `o` on(((`o`.`facility_id` = `f`.`facility_id`) and (`o`.`status` in ('confirmed','in_progress')) and (`cal`.`date` between `o`.`start_date` and `o`.`end_date`)))) where (`cal`.`date` between curdate() and (curdate() + interval 90 day)) group by `f`.`facility_id`,`cal`.`date`;

SET FOREIGN_KEY_CHECKS = 1;
