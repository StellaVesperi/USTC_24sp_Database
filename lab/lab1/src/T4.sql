USE lab1;
DELIMITER //

DROP PROCEDURE IF EXISTS borrowBook;

CREATE PROCEDURE borrowBook(IN readerID CHAR(8), IN bookID CHAR(8), OUT return_info CHAR(20))
BEGIN
    DECLARE s INT DEFAULT 0;
    DECLARE borrow_count INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR 1146 SET s = 1;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET s = 2;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET s = 3;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET s = 4;
    START TRANSACTION;

    -- a) 同一天不允许同一个读者重复借阅同一本书；
    IF EXISTS (SELECT 1 FROM Borrow WHERE reader_ID = readerID AND book_ID = bookID AND borrow_Date = '2024-05-09') THEN
        SET s = 5;
    END IF;

    -- b) 如果该图书存在预约记录，而当前借阅者没有预约，则不允许借阅；
    IF s = 0 AND bookID IN (SELECT book_ID FROM Reserve WHERE reader_ID != readerID AND book_ID = bookID) AND 
       bookID NOT IN (SELECT book_ID FROM Reserve WHERE reader_ID = readerID AND book_ID = bookID) THEN
        SET s = 6;
    END IF;

    -- c) 一个读者最多只能借阅 3 本图书，意味着如果读者已经借阅了 3 本图书并且未归还则不允许再借书；
    IF s = 0 THEN
        SELECT COUNT(*) INTO borrow_count FROM Borrow WHERE reader_ID = readerID AND return_Date IS NULL;
        IF borrow_count >= 3 THEN
            SET s = 7;
        END IF;
    END IF;

    -- d) 如果借阅者已经预约了该图书，则允许借阅，但要求借阅完成后删除借阅者对该图书的预约记录；
    IF s = 0 AND bookID IN (SELECT book_ID FROM Reserve WHERE reader_ID = readerID AND book_ID = bookID) THEN
        DELETE FROM Reserve WHERE book_ID = bookID AND reader_ID = readerID;
    END IF;

    -- e) 借阅成功后图书表中的 borrow_Times 加 1；
    -- f) 借阅成功后修改状态。
    IF s = 0 THEN
        UPDATE Book SET borrow_Times = borrow_Times + 1, bstatus = 1 WHERE bid = bookID;
        INSERT INTO Borrow (book_ID, reader_ID, borrow_Date, return_Date)
            VALUES (bookID, readerID, '2024-05-09', NULL);
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
                SET return_info = 'duplicate borrow';
            WHEN 6 THEN
                SET return_info = 'reserved by others';
            WHEN 7 THEN
                SET return_info = 'max borrow nums';
        END CASE;
        ROLLBACK;
    END IF;
END //
DELIMITER ;
