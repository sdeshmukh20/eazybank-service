-- Rollback script from Version 2 to Version 1

-- Drop all the new tables created in version 2
DROP TABLE IF EXISTS `account_transactions`;
DROP TABLE IF EXISTS `accounts`;
DROP TABLE IF EXISTS `loans`;
DROP TABLE IF EXISTS `cards`;
DROP TABLE IF EXISTS `notice_details`;
DROP TABLE IF EXISTS `contact_messages`;

-- Modify the `customer` table structure to match version 1
DROP TABLE IF EXISTS `customer`;

-- Recreate the `customer` table as per version 1
CREATE TABLE `customer` (
                            `id` int NOT NULL AUTO_INCREMENT,
                            `email` varchar(45) NOT NULL,
                            `pwd` varchar(200) NOT NULL,
                            `role` varchar(45) NOT NULL,
                            PRIMARY KEY (`id`)
);

-- Insert data into `customer` table (as per version 1)
INSERT INTO `customer` (`email`, `pwd`, `role`) VALUES
                                                    ('happy@example.com', '{noop}EazyBytes@12345', 'read'),
                                                    ('admin@example.com', '{bcrypt}$2a$12$88.f6upbBvy0okEa7OfHFuorV29qeK.sVbB9VQ6J6dWM1bW6Qef8m', 'admin');

-- Recreate the `users` table as per version 1
CREATE TABLE `users` (
                         `username` varchar(50) NOT NULL PRIMARY KEY,
                         `password` varchar(500) NOT NULL,
                         `enabled` boolean NOT NULL
);

-- Insert data into `users` table
INSERT INTO `users` VALUES
                        ('user', '{noop}EazyBytes@12345', '1'),
                        ('admin', '{bcrypt}$2a$12$88.f6upbBvy0okEa7OfHFuorV29qeK.sVbB9VQ6J6dWM1bW6Qef8m', '1');

-- Recreate the `authorities` table as per version 1
CREATE TABLE `authorities` (
                               `username` varchar(50) NOT NULL,
                               `authority` varchar(50) NOT NULL,
                               CONSTRAINT fk_authorities_users FOREIGN KEY (`username`) REFERENCES `users` (`username`)
);

-- Create unique index on `authorities`
CREATE UNIQUE INDEX ix_auth_username ON `authorities` (`username`, `authority`);

-- Insert data into `authorities` table
INSERT INTO `authorities` VALUES
                              ('user', 'read'),
                              ('admin', 'admin');
