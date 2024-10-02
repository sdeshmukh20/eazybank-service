-- Rollback from scriptv2 to scriptv1

-- Drop all new tables created in scriptv2
DROP TABLE IF EXISTS `contact_messages`;
DROP TABLE IF EXISTS `notice_details`;
DROP TABLE IF EXISTS `cards`;
DROP TABLE IF EXISTS `loans`;
DROP TABLE IF EXISTS `account_transactions`;
DROP TABLE IF EXISTS `accounts`;
DROP TABLE IF EXISTS `customer`;

-- Recreate tables from scriptv1
CREATE TABLE `customer` (
                            `customer_id` int NOT NULL AUTO_INCREMENT,
                            `name` varchar(100) NOT NULL,
                            `email` varchar(100) NOT NULL,
                            `mobile_number` varchar(20) NOT NULL,
                            `pwd` varchar(500) NOT NULL,
                            `role` varchar(100) NOT NULL,
                            `create_dt` date DEFAULT NULL,
                            PRIMARY KEY (`customer_id`)
);

INSERT INTO `customer` (`name`,`email`,`mobile_number`, `pwd`, `role`,`create_dt`)
VALUES ('Happy','happy@example.com','5334122365', '{bcrypt}$2a$12$88.f6upbBvy0okEa7OfHFuorV29qeK.sVbB9VQ6J6dWM1bW6Qef8m', 'admin',CURDATE());

CREATE TABLE `accounts` (
                            `customer_id` int NOT NULL,
                            `account_number` int NOT NULL,
                            `account_type` varchar(100) NOT NULL,
                            `branch_address` varchar(200) NOT NULL,
                            `create_dt` date DEFAULT NULL,
                            PRIMARY KEY (`account_number`),
                            KEY `customer_id` (`customer_id`),
                            CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE
);

INSERT INTO `accounts` (`customer_id`, `account_number`, `account_type`, `branch_address`, `create_dt`)
VALUES (1, 1865764534, 'Savings', '123 Main Street, New York', CURDATE());

CREATE TABLE `account_transactions` (
                                        `transaction_id` varchar(200) NOT NULL,
                                        `account_number` int NOT NULL,
                                        `customer_id` int NOT NULL,
                                        `transaction_dt` date NOT NULL,
                                        `transaction_summary` varchar(200) NOT NULL,
                                        `transaction_type` varchar(100) NOT NULL,
                                        `transaction_amt` int NOT NULL,
                                        `closing_balance` int NOT NULL,
                                        `create_dt` date DEFAULT NULL,
                                        PRIMARY KEY (`transaction_id`),
                                        KEY `customer_id` (`customer_id`),
                                        KEY `account_number` (`account_number`),
                                        CONSTRAINT `accounts_ibfk_2` FOREIGN KEY (`account_number`) REFERENCES `accounts` (`account_number`) ON DELETE CASCADE,
                                        CONSTRAINT `acct_user_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE
);

-- Insert transactions from scriptv1
INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`, `transaction_summary`, `transaction_type`, `transaction_amt`, `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 7 DAY), 'Coffee Shop', 'Withdrawal', 30, 34500, DATE_SUB(CURDATE(), INTERVAL 7 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`, `transaction_summary`, `transaction_type`, `transaction_amt`, `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), 'Uber', 'Withdrawal', 100, 34400, DATE_SUB(CURDATE(), INTERVAL 6 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`, `transaction_summary`, `transaction_type`, `transaction_amt`, `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Self Deposit', 'Deposit', 500, 34900, DATE_SUB(CURDATE(), INTERVAL 5 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`, `transaction_summary`, `transaction_type`, `transaction_amt`, `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Ebay', 'Withdrawal', 600, 34300, DATE_SUB(CURDATE(), INTERVAL 4 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`, `transaction_summary`, `transaction_type`, `transaction_amt`, `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 'OnlineTransfer', 'Deposit', 700, 35000, DATE_SUB(CURDATE(), INTERVAL 2 DAY));

INSERT INTO `account_transactions` (`transaction_id`, `account_number`, `customer_id`, `transaction_dt`, `transaction_summary`, `transaction_type`, `transaction_amt`, `closing_balance`, `create_dt`)
VALUES (UUID(), 1865764534, 1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Amazon.com', 'Withdrawal', 100, 34900, DATE_SUB(CURDATE(), INTERVAL 1 DAY));

-- Recreate loans table from scriptv1
CREATE TABLE `loans` (
                         `loan_number` int NOT NULL AUTO_INCREMENT,
                         `customer_id` int NOT NULL,
                         `start_dt` date NOT NULL,
                         `loan_type` varchar(100) NOT NULL,
                         `total_loan` int NOT NULL,
                         `amount_paid` int NOT NULL,
                         `outstanding_amount` int NOT NULL,
                         `create_dt` date DEFAULT NULL,
                         PRIMARY KEY (`loan_number`),
                         KEY `customer_id` (`customer_id`),
                         CONSTRAINT `loan_customer_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE
);

-- Insert loans from scriptv1
INSERT INTO `loans` (`customer_id`, `start_dt`, `loan_type`, `total_loan`, `amount_paid`, `outstanding_amount`, `create_dt`)
VALUES (1, '2020-10-13', 'Home', 200000, 50000, 150000, '2020-10-13');

INSERT INTO `loans` (`customer_id`, `start_dt`, `loan_type`, `total_loan`, `amount_paid`, `outstanding_amount`, `create_dt`)
VALUES (1, '2020-06-06', 'Vehicle', 40000, 10000, 30000, '2020-06-06');

INSERT INTO `loans` (`customer_id`, `start_dt`, `loan_type`, `total_loan`, `amount_paid`, `outstanding_amount`, `create_dt`)
VALUES (1, '2018-02-14', 'Home', 50000, 10000, 40000, '2018-02-14');

INSERT INTO `loans` (`customer_id`, `start_dt`, `loan_type`, `total_loan`, `amount_paid`, `outstanding_amount`, `create_dt`)
VALUES (1, '2018-02-14', 'Personal', 10000, 3500, 6500, '2018-02-14');

-- Recreate cards table from scriptv1
CREATE TABLE `cards` (
                         `card_id` int NOT NULL AUTO_INCREMENT,
                         `card_number` varchar(100) NOT NULL,
                         `customer_id` int NOT NULL,
                         `card_type` varchar(100) NOT NULL,
                         `total_limit` int NOT NULL,
                         `amount_used` int NOT NULL,
                         `available_amount` int NOT NULL,
                         `create_dt` date DEFAULT NULL,
                         PRIMARY KEY (`card_id`),
                         KEY `customer_id` (`customer_id`),
                         CONSTRAINT `card_customer_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE
);

-- Insert cards from scriptv1
INSERT INTO `cards` (`card_number`, `customer_id`, `card_type`, `total_limit`, `amount_used`, `available_amount`, `create_dt`)
VALUES ('4565XXXX4656', 1, 'Credit', 10000, 500, 9500, CURDATE());

INSERT INTO `cards` (`card_number`, `customer_id`, `card_type`, `total_limit`, `amount_used`, `available_amount`, `create_dt`)
VALUES ('3455XXXX8673', 1, 'Credit', 7500, 600, 6900, CURDATE());

INSERT INTO `cards` (`card_number`, `customer_id`, `card_type`, `total_limit`, `amount_used`, `available_amount`, `create_dt`)
VALUES ('2359XXXX9346', 1, 'Credit', 20000, 4000, 16000, CURDATE());

-- Recreate notice_details table from scriptv1
CREATE TABLE `notice_details` (
                                  `notice_id` int NOT NULL AUTO_INCREMENT,
                                  `notice_summary` varchar(200) NOT NULL,
                                  `notice_details` varchar(500) NOT NULL,
                                  `notic_beg_dt` date NOT NULL,
                                  `notic_end_dt` date NOT NULL,
                                  `create_dt` date DEFAULT NULL,
                                  PRIMARY KEY (`notice_id`)
);

-- Insert notices from scriptv1
INSERT INTO `notice_details` (`notice_summary`, `notice_details`, `notic_beg_dt`, `notic_end_dt`, `create_dt`)
VALUES ('Maintenance Notice', 'We will be shutting down our servers for maintenance from 01:00 AM to 03:00 AM on the 26th of September. Please bear with us.', '2023-09-26', '2023-09-26', CURDATE());

INSERT INTO `notice_details` (`notice_summary`, `notice_details`, `notic_beg_dt`, `notic_end_dt`, `create_dt`)
VALUES ('Interest Rate Change', 'The interest rates for all types of loans will increase by 0.5% from the 1st of October.', '2023-09-30', '2023-10-01', CURDATE());

-- Recreate contact_messages table from scriptv1
CREATE TABLE `contact_messages` (
                                    `contact_id` int NOT NULL AUTO_INCREMENT,
                                    `contact_name` varchar(100) NOT NULL,
                                    `contact_email` varchar(100) NOT NULL,
                                    `subject` varchar(100) NOT NULL,
                                    `message` varchar(500) NOT NULL,
                                    `create_dt` date DEFAULT NULL,
                                    PRIMARY KEY (`contact_id`)
);

-- Insert contact messages from scriptv1
INSERT INTO `contact_messages` (`contact_name`, `contact_email`, `subject`, `message`, `create_dt`)
VALUES ('John Doe', 'john.doe@example.com', 'Issue with account login', 'Unable to log in to the account. Error shows invalid credentials.', CURDATE());

-- Drop any other changes made in scriptv2
-- (If any additional tables/columns were added, drop or alter them as necessary)
