mysql> USE hotel_management_system;
Database changed
mysql> SHOW DATABASES;
+-------------------------+
| Database                |
+-------------------------+
| hotel_management        |
| hotel_management_system |
| information_schema      |
| mysql                   |
| performance_schema      |
| sys                     |
+-------------------------+
6 rows in set (0.03 sec)

mysql> SHOW TABLES;
+-----------------------------------+
| Tables_in_hotel_management_system |
+-----------------------------------+
| booking                           |
| customers                         |
| manager                           |
| rooms                             |
| staff                             |
+-----------------------------------+
5 rows in set (0.01 sec)

mysql> SELECT * FROM rooms;
+--------+----------+------------+-------------+---------+-----------+
| roomId | roomType | bedNumbers | isAvailable | isClean | isSmoking |
+--------+----------+------------+-------------+---------+-----------+
|    101 | Single   |          1 |           1 |       1 |         0 |
|    102 | Double   |          2 |           1 |       1 |         0 |
|    103 | Suite    |          2 |           0 |       1 |         1 |
|    104 | Single   |          1 |           1 |       1 |         0 |
+--------+----------+------------+-------------+---------+-----------+
4 rows in set (0.00 sec)

mysql> SELECT * FROM customers;
+------------+--------------+----------------+----------------+----------------+ 
| customerId | customerName | customerEmail  | customerGender | customerPoints | 
+------------+--------------+----------------+----------------+----------------+ 
|          1 | John Doe     | john@email.com | Male           |            168 |
|          2 | Jane Smith   | jane@email.com | Female         |            200 | 
+------------+--------------+----------------+----------------+----------------+ 
2 rows in set (0.00 sec)

mysql> SELECT * FROM bookings;
ERROR 1146 (42S02): Table 'hotel_management_system.bookings' doesn't exist
mysql> ALTER TABLE rooms ADD PRIMARY KEY (roomId);
ERROR 1068 (42000): Multiple primary key defined
mysql> SELECT COUNT(*) AS total_rooms FROM rooms;
+-------------+
| total_rooms |
+-------------+
|           4 |
+-------------+
1 row in set (0.00 sec)

mysql> SELECT AVG(price_per_night) AS average_price FROM rooms;
ERROR 1054 (42S22): Unknown column 'price_per_night' in 'field list'
mysql> ALTER TABLE rooms ADD PRIMARY KEY (roomId);
ERROR 1068 (42000): Multiple primary key defined
mysql> DESCRIBE rooms;
+-------------+-------------+------+-----+---------+-------+
| Field       | Type        | Null | Key | Default | Extra |
+-------------+-------------+------+-----+---------+-------+
| roomId      | int         | NO   | PRI | NULL    |       |
| roomType    | varchar(10) | YES  |     | NULL    |       |
| bedNumbers  | int         | YES  |     | NULL    |       |
| isAvailable | tinyint(1)  | YES  |     | NULL    |       |
| isClean     | tinyint(1)  | YES  |     | NULL    |       |
| isSmoking   | tinyint(1)  | YES  |     | NULL    |       |
+-------------+-------------+------+-----+---------+-------+
6 rows in set (0.02 sec)

mysql> DESCRIBE customers;
+----------------+-------------+------+-----+---------+-------+
| Field          | Type        | Null | Key | Default | Extra |
+----------------+-------------+------+-----+---------+-------+
| customerId     | int         | NO   | PRI | NULL    |       |
| customerName   | varchar(50) | YES  |     | NULL    |       |
| customerEmail  | varchar(50) | YES  |     | NULL    |       |
| customerGender | varchar(6)  | YES  |     | NULL    |       |
| customerPoints | int         | YES  |     | NULL    |       |
+----------------+-------------+------+-----+---------+-------+
5 rows in set (0.00 sec)

mysql> DESCRIBE bookings;
ERROR 1146 (42S02): Table 'hotel_management_system.bookings' doesn't exist
mysql> ALTER TABLE customers ADD CONSTRAINT chk_points CHECK (customerPoints >= 0);
Query OK, 2 rows affected (0.14 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE rooms ADD CONSTRAINT chk_beds CHECK (bedNumbers >= 1);
Query OK, 4 rows affected (0.17 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> SELECT r.roomId, r.roomType, r.bedNumbers, c.customerName, c.customerPoints
    -> FROM rooms r, customers c
    -> WHERE r.isAvailable = 1;
+--------+----------+------------+--------------+----------------+
| roomId | roomType | bedNumbers | customerName | customerPoints |
+--------+----------+------------+--------------+----------------+
|    104 | Single   |          1 | John Doe     |            168 |
|    102 | Double   |          2 | John Doe     |            168 |
|    101 | Single   |          1 | John Doe     |            168 |
|    104 | Single   |          1 | Jane Smith   |            200 |
|    102 | Double   |          2 | Jane Smith   |            200 |
|    101 | Single   |          1 | Jane Smith   |            200 |
+--------+----------+------------+--------------+----------------+
6 rows in set (0.01 sec)

mysql> SELECT SUM(customerPoints) AS total_points FROM customers;
+--------------+
| total_points |
+--------------+
|          368 |
+--------------+
1 row in set (0.01 sec)

mysql> SELECT COUNT(*) AS available_rooms FROM rooms WHERE isAvailable = 1;
+-----------------+
| available_rooms |
+-----------------+
|               3 |
+-----------------+
1 row in set (0.00 sec)

mysql> SELECT roomId, roomType FROM rooms WHERE isClean = 1;
+--------+----------+
| roomId | roomType |
+--------+----------+
|    101 | Single   |
|    102 | Double   |
|    103 | Suite    |
|    104 | Single   |
+--------+----------+
4 rows in set (0.00 sec)

mysql> SELECT roomId, roomType FROM rooms WHERE isSmoking = 1;
+--------+----------+
| roomId | roomType |
+--------+----------+
|    103 | Suite    |
+--------+----------+
1 row in set (0.00 sec)

mysql> SELECT roomId, roomType FROM rooms WHERE isAvailable = 1 AND isClean = 1;
+--------+----------+
| roomId | roomType |
+--------+----------+
|    101 | Single   |
|    102 | Double   |
|    104 | Single   |
+--------+----------+
3 rows in set (0.00 sec)

mysql> SELECT roomId, roomType, bedNumbersFROM roomsWHERE bedNumbers = (SELECT MAX(bedNumbers) FROM rooms);
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'bedNumbers = (SELECT MAX(bedNumbers) FROM rooms)' at line 1
mysql> SELECT roomId, roomType, bedNumbersFROM rooms WHERE bedNumbers = (SELECT M
AX(bedNumbers) FROM rooms);
ERROR 1054 (42S22): Unknown column 'roomId' in 'field list'
mysql> SELECT roomId, roomType, bedNumbers FROM rooms WHERE bedNumbers = (SELECT MAX(bedNumbers) FROM rooms);
+--------+----------+------------+
| roomId | roomType | bedNumbers |
+--------+----------+------------+
|    102 | Double   |          2 |
|    103 | Suite    |          2 |
+--------+----------+------------+
2 rows in set (0.00 sec)

mysql> SELECT customerId, customerName, customerPoints FROM customers WHERE customerPoints = (SELECT MAX(customerPoints) FROM customers);
+------------+--------------+----------------+
| customerId | customerName | customerPoints |
+------------+--------------+----------------+
|          2 | Jane Smith   |            200 |
+------------+--------------+----------------+
1 row in set (0.00 sec)

mysql> SELECT customerId, customerName, customerPoints FROM customers WHERE customerPoints > (SELECT AVG(customerPoints) FROM customers);
+------------+--------------+----------------+
| customerId | customerName | customerPoints |
+------------+--------------+----------------+
|          2 | Jane Smith   |            200 |
+------------+--------------+----------------+
1 row in set (0.00 sec)

mysql> SELECT r.roomId, r.roomType, c.customerName, c.customerPoints FROM rooms r INNER JOIN customers c ON r.isAvailable = 1;
+--------+----------+--------------+----------------+
| roomId | roomType | customerName | customerPoints |
+--------+----------+--------------+----------------+
|    104 | Single   | John Doe     |            168 |
|    102 | Double   | John Doe     |            168 |
|    101 | Single   | John Doe     |            168 |
|    104 | Single   | Jane Smith   |            200 |
|    102 | Double   | Jane Smith   |            200 |
|    101 | Single   | Jane Smith   |            200 |
+--------+----------+--------------+----------------+
6 rows in set (0.00 sec)

mysql> SELECT r.roomId, r.roomType, r.isAvailable, c.customerName FROM rooms r LEFT JOIN customers c ON r.roomId = c.customerId;
+--------+----------+-------------+--------------+
| roomId | roomType | isAvailable | customerName |
+--------+----------+-------------+--------------+
|    101 | Single   |           1 | NULL         |
|    102 | Double   |           1 | NULL         |
|    103 | Suite    |           0 | NULL         |
|    104 | Single   |           1 | NULL         |
+--------+----------+-------------+--------------+
4 rows in set (0.00 sec)

mysql> SELECT r.roomId, r.roomType, c.customerName, c.customerPoints FROM rooms r, customers c WHERE r.isAvailable = 1;
+--------+----------+--------------+----------------+
| roomId | roomType | customerName | customerPoints |
+--------+----------+--------------+----------------+
|    104 | Single   | John Doe     |            168 |
|    102 | Double   | John Doe     |            168 |
|    101 | Single   | John Doe     |            168 |
|    104 | Single   | Jane Smith   |            200 |
|    102 | Double   | Jane Smith   |            200 |
|    101 | Single   | Jane Smith   |            200 |
+--------+----------+--------------+----------------+
6 rows in set (0.00 sec)

mysql> CREATE VIEW available_rooms AS SELECT roomId, roomType, bedNumbers FROM rooms WHERE isAvailable = 1 AND isClean = 1;
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT * FROM available_rooms;
+--------+----------+------------+
| roomId | roomType | bedNumbers |
+--------+----------+------------+
|    101 | Single   |          1 |
|    102 | Double   |          2 |
|    104 | Single   |          1 |
+--------+----------+------------+
3 rows in set (0.02 sec)

mysql> UPDATE rooms SET isAvailable = 0 WHERE roomId = 101;
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM room_audit;
ERROR 1146 (42S02): Table 'hotel_management_system.room_audit' doesn't exist
mysql> CREATE TABLE IF NOT EXISTS room_audit (    audit_id INT AUTO_INCREMENT PRIMARY KEY,    room_id INT,    old_status BOOLEAN,    new_status BOOLEAN,    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
Query OK, 0 rows affected (0.04 sec)

mysql> DELIMITER $$ CREATE TRIGGER room_availability_audit AFTER UPDATE ON rooms FOR EACH ROW BEGIN IF OLD.isAvailable != NEW.isAvailable THEN INSERT INTO room_audit(room_id, old_status, new_status) VALUES (NEW.roomId, OLD.isAvailable, NEW.isAvailable); END IF; END$$ DELIMITER ;
mysql> UPDATE rooms SET isAvailable = 0 WHERE roomId = 101;
    -> ^C
mysql> UPDATE rooms SET isAvailable = 0 WHERE roomId = 101;
    -> ^C
mysql> SELECT * FROM room_audit;
    -> ^C
mysql> SELECT roomId, isAvailable FROM rooms WHERE roomId = 101;
    -> DELIMITER ;
    -> ^C
mysql> DELIMITER ;
mysql> SELECT roomId, isAvailable FROM rooms WHERE roomId = 101;
+--------+-------------+
| roomId | isAvailable |
+--------+-------------+
|    101 |           0 |
+--------+-------------+
1 row in set (0.00 sec)

mysql> UPDATE rooms SET isAvailable = 1 WHERE roomId = 101;
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> UPDATE rooms SET isAvailable = 0 WHERE roomId = 101;
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM room_audit;
Empty set (0.00 sec)

mysql> SELECT roomId, isAvailable FROM rooms;
+--------+-------------+
| roomId | isAvailable |
+--------+-------------+
|    101 |           0 |
|    102 |           1 |
|    103 |           0 |
|    104 |           1 |
+--------+-------------+
4 rows in set (0.00 sec)

mysql> UPDATE rooms SET isAvailable = 0 WHERE roomId = 101;
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> SELECT * FROM room_audit;
Empty set (0.00 sec)

mysql> SHOW TRIGGERS;
Empty set (0.02 sec)

mysql> SHOW TABLES LIKE 'room_audit';
+------------------------------------------------+
| Tables_in_hotel_management_system (room_audit) |
+------------------------------------------------+
| room_audit                                     |
+------------------------------------------------+
1 row in set (0.02 sec)

mysql> DELIMITER $$CREATE TRIGGER room_availability_auditAFTER UPDATE ON roomsFOR EACH ROWBEGIN    INSERT INTO room_audit(room_id, old_status, new_status)    VALUES (NEW.roomId, OLD.isAvailable, NEW.isAvailable);END$$DELIMITER ;
mysql> SELECT roomId, isAvailable FROM rooms;
    -> UPDATE rooms SET isAvailable = 0 WHERE roomId = 101;
    -> DELIMITER ;
    -> DELIMITER ;
    -> ^C
mysql> DELIMITER ;
mysql> SELECT roomId, isAvailable FROM rooms;
+--------+-------------+
| roomId | isAvailable |
+--------+-------------+
|    101 |           0 |
|    102 |           1 |
|    103 |           0 |
|    104 |           1 |
+--------+-------------+
4 rows in set (0.00 sec)

mysql> UPDATE rooms SET isAvailable = 0 WHERE roomId = 101;
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> SELECT * FROM room_audit;
Empty set (0.00 sec)

mysql> DELIMITER $$CREATE TRIGGER room_availability_auditAFTER UPDATE ON roomsFOR EACH ROWBEGIN    INSERT INTO room_audit(room_id, old_status, new_status)    VALUES (NEW.roomId, OLD.isAvailable, NEW.isAvailable);END$$
mysql> DELIMITER ;
mysql> SELECT * FROM rooms;
+--------+----------+------------+-------------+---------+-----------+
| roomId | roomType | bedNumbers | isAvailable | isClean | isSmoking |
+--------+----------+------------+-------------+---------+-----------+
|    101 | Single   |          1 |           0 |       1 |         0 |
|    102 | Double   |          2 |           1 |       1 |         0 |
|    103 | Suite    |          2 |           0 |       1 |         1 |
|    104 | Single   |          1 |           1 |       1 |         0 |
+--------+----------+------------+-------------+---------+-----------+
4 rows in set (0.00 sec)

mysql> SELECT roomId, isAvailable FROM rooms;
+--------+-------------+
| roomId | isAvailable |
+--------+-------------+
|    101 |           0 |
|    102 |           1 |
|    103 |           0 |
|    104 |           1 |
+--------+-------------+
4 rows in set (0.00 sec)

mysql> UPDATE rooms SET isAvailable = 1 WHERE roomId = 101;
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> UPDATE rooms SET isAvailable = 0 WHERE roomId = 101;
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM room_audit;
Empty set (0.00 sec)

mysql> SHOW TRIGGERS;
Empty set (0.00 sec)

mysql> CREATE TABLE IF NOT EXISTS room_audit ( audit_id INT AUTO_INCREMENT PRIMARY KEY, room_id INT, old_status BOOLEAN, new_status BOOLEAN, change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP );
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> DELIMITER $$ CREATE TRIGGER room_availability_audit AFTER UPDATE ON rooms FOR EACH ROW BEGIN IF OLD.isAvailable != NEW.isAvailable THEN INSERT INTO room_audit(room_id, old_status, new_status) VALUES (NEW.roomId, OLD.isAvailable, NEW.isAvailable); END IF; END$$ DELIMITER ;
mysql> DELIMITER ;
mysql> UPDATE rooms SET isAvailable = 0 WHERE roomId = 101;
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> SELECT * FROM room_audit;
Empty set (0.00 sec)

mysql> DELIMITER $$ CREATE PROCEDURE display_all_rooms() BEGIN DECLARE done INT DEFAULT FALSE; DECLARE r_id INT; DECLARE r_type VARCHAR(10); DECLARE r_beds INT; DECLARE r_avail BOOLEAN; DECLARE cur CURSOR FOR SELECT roomId, roomType, bedNumbers, isAvailable FROM rooms; DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; OPEN cur; read_loop: LOOP FETCH cur INTO r_id, r_type, r_beds, r_avail; IF done THEN LEAVE read_loop; END IF; SELECT r_id AS Room_ID, r_type AS Room_Type, r_beds AS Bed_Number, r_avail AS Is_Available; END LOOP; CLOSE cur; END$$ DELIMITER ; 
mysql> DELIMITER $$ CREATE PROCEDURE display_all_rooms() BEGIN DECLARE done INT DEFAULT FALSE; DECLARE r_id INT; DECLARE r_type VARCHAR(10); DECLARE r_beds INT; DECLARE r_avail BOOLEAN; DECLARE cur CURSOR FOR SELECT roomId, roomType, bedNumbers, isAvailable FROM rooms; DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; OPEN cur; read_loop: LOOP FETCH cur INTO r_id, r_type, r_beds, r_avail; IF done THEN LEAVE read_loop; END IF; SELECT r_id AS Room_ID, r_type AS Room_Type, r_beds AS Bed_Number, r_avail AS Is_Available; END LOOP; CLOSE cur; END$$ DELIMITER ;^C
mysql> DELIMITER ; 
mysql> CALL display_all_rooms();
ERROR 1305 (42000): PROCEDURE hotel_management_system.display_all_rooms does not exist
mysql> DELIMITER $$
mysql> 
mysql> CREATE PROCEDURE display_all_rooms()
    -> BEGIN
    ->     DECLARE done INT DEFAULT FALSE;
    ->     DECLARE r_id INT;
    ->     DECLARE r_type VARCHAR(10);
    ->     DECLARE r_beds INT;
    ->     DECLARE r_avail BOOLEAN;
    ->
    ->     DECLARE cur CURSOR FOR SELECT roomId, roomType, bedNumbers, isAvailable FROM rooms;
    ->     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    ->
    ->     OPEN cur;
    ->
    ->     read_loop: LOOP
    ->         FETCH cur INTO r_id, r_type, r_beds, r_avail;
    ->
    ->         IF done THEN
    ->             LEAVE read_loop;
    ->         END IF;
    ->
    ->         SELECT r_id AS Room_ID, r_type AS Room_Type,
    ->                r_beds AS Bed_Number, r_avail AS Is_Available;
    ->     END LOOP;
    ->
    ->     CLOSE cur;
    -> END$$
Query OK, 0 rows affected (0.03 sec)

mysql>
mysql> DELIMITER ;
mysql> CALL display_all_rooms();
+---------+-----------+------------+--------------+
| Room_ID | Room_Type | Bed_Number | Is_Available |
+---------+-----------+------------+--------------+
|     101 | Single    |          1 |            0 |
+---------+-----------+------------+--------------+
1 row in set (0.01 sec)

+---------+-----------+------------+--------------+
| Room_ID | Room_Type | Bed_Number | Is_Available |
+---------+-----------+------------+--------------+
|     102 | Double    |          2 |            1 |
+---------+-----------+------------+--------------+
1 row in set (0.01 sec)

+---------+-----------+------------+--------------+
| Room_ID | Room_Type | Bed_Number | Is_Available |
+---------+-----------+------------+--------------+
|     103 | Suite     |          2 |            0 |
+---------+-----------+------------+--------------+
1 row in set (0.01 sec)

+---------+-----------+------------+--------------+
| Room_ID | Room_Type | Bed_Number | Is_Available |
+---------+-----------+------------+--------------+
|     104 | Single    |          1 |            1 |
+---------+-----------+------------+--------------+
1 row in set (0.02 sec)

Query OK, 0 rows affected (0.02 sec)

mysql>



|     103 | Suite     |          2 |            0 |
+---------+-----------+------------+--------------+
1 row in set (0.01 sec)

+---------+-----------+------------+--------------+
| Room_ID | Room_Type | Bed_Number | Is_Available |
+---------+-----------+------------+--------------+
|     104 | Single    |          1 |            1 |
+---------+-----------+------------+--------------+
1 row in set (0.02 sec)

Query OK, 0 rows affected (0.02 sec)
