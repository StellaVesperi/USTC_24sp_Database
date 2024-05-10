USE lab1;
DELIMITER //

DROP PROCEDURE IF EXISTS returnBook;

CREATE PROCEDURE returnBook(IN readerID CHAR(8), IN bookID CHAR(8), OUT return_info CHAR(20))
BEGIN
    DECLARE s INT DEFAULT 0;
    DECLARE affected_rows INT;
    DECLARE CONTINUE HANDLER FOR 1146 SET s = 1;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET s = 2;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET s = 5; -- Not found handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET s = 4;
    START TRANSACTION;

    -- 更新借阅记录，设置返回日期为2024-05-10
    UPDATE Borrow
    SET return_Date = '2024-05-10'
    WHERE reader_ID = readerID AND book_ID = bookID;

    SET affected_rows = ROW_COUNT(); -- 获取影响的行数

    -- 检查是否有未取消的预约
    IF EXISTS (SELECT 1 FROM Reserve WHERE book_ID = bookID) THEN
        -- 如果有预约，则更新书籍状态为已预约（2）
        UPDATE Book
        SET bstatus = 2
        WHERE bid = bookID;
    ELSE
        -- 如果没有预约，则更新书籍状态为可借（0）
        UPDATE Book
        SET bstatus = 0
        WHERE bid = bookID;
    END IF;

    SET foreign_key_checks = 1;

    -- 如果没有行被更新（即没有找到借阅记录），设置错误信息
    IF affected_rows = 0 THEN
        SET s = 3; -- Not found
    END IF;

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
                SET return_info = 'not found';  -- 没有找到借阅记录，还书失败
            WHEN 4 THEN
                SET return_info = 'sql exception';
            WHEN 5 THEN
                SET return_info = 'not found';
        END CASE;
        ROLLBACK;
    END IF;
END //
DELIMITER ;
