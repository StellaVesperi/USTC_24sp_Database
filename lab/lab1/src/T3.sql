USE lab1;
DELIMITER //

DROP PROCEDURE IF EXISTS updateReaderID;

CREATE PROCEDURE updateReaderID(IN oldID CHAR(8), IN newID CHAR(8), OUT return_info CHAR(20))
BEGIN
    DECLARE s INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR 1146 SET s = 1;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET s = 2;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET s = 3;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET s = 4;

    START TRANSACTION;

    -- Temporary disable foreign key checks
    SET foreign_key_checks = 0;

    IF oldID NOT IN (SELECT rid FROM Reader) THEN
        SET s = 3;
    ELSEIF newID IN (SELECT rid FROM Reader) THEN
        SET s = 5;
    ELSE
        UPDATE Reader SET rid = newID WHERE rid = oldID;
        UPDATE Borrow SET reader_ID = newID WHERE reader_ID = oldID;
        UPDATE Reserve SET reader_ID = newID WHERE reader_ID = oldID;
    END IF;

    -- Re-enable foreign key checks
    SET foreign_key_checks = 1;

    IF s = 0 THEN
        SET return_info = 'ok';
        COMMIT;
    ELSE
        CASE s
            WHEN 1 THEN
                SET return_info = 'no such table';
            WHEN 2 THEN
                SET return_info = 'no such table';
            WHEN 3 THEN
                SET return_info = 'not found';
            WHEN 4 THEN
                SET return_info = 'sql exception';
            WHEN 5 THEN
                SET return_info = 'duplicate ID';
        END CASE;
        ROLLBACK;
    END IF;
END //

DELIMITER ;
