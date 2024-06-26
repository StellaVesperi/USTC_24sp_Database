drop trigger if exists AutoUpdateWhenInsert;
Delimiter //
Create Trigger AutoUpdateWhenInsert After Insert ON Reserve For Each Row
BEGIN
    -- 当一本书被预约时, 自动将 Book 表中相应图书的 status 修改为 2，并增加 reserve_Times；
    UPDATE Book
    set bstatus=2, reserve_Times = reserve_Times+1
    where bid = new.book_ID;
END //
DELIMITER ;

drop trigger if exists AutoUpdateWhenDelete;
Delimiter //
Create Trigger AutoUpdateWhenDelete After DELETE ON Reserve For Each Row
BEGIN
    -- 当某本预约的书被借出时或者读者取消预约时, 自动减少 reserve_Times
    UPDATE Book
    set reserve_Times = reserve_Times - 1
    where bid = old.book_ID;
    IF NOT EXISTS(
        SELECT * FROM Reserve WHERE book_id = OLD.book_id
    ) THEN
        UPDATE Book SET bstatus = 0 WHERE bid = OLD.book_id;
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS AutoUpdateBookStatus;
DELIMITER //
CREATE TRIGGER AutoUpdateBookStatus AFTER DELETE ON Reserve FOR EACH ROW
BEGIN
    -- 如果没有剩余预约并且书籍状态为2（被预约），更新状态为0（可借）
    IF (SELECT COUNT(*) FROM Reserve WHERE book_id = OLD.book_ID) = 0 THEN
        UPDATE Book
        SET bstatus = 0
        WHERE bid = OLD.book_ID AND bstatus = 2;
    END IF;
END //
DELIMITER ;
