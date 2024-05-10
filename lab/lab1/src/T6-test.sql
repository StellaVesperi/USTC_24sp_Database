-- 插入预约记录
INSERT INTO Reserve (book_ID, reader_ID, reserve_Date, take_Date)
VALUES ('B012', 'R001', CURDATE(), CURDATE() + INTERVAL 1 DAY);

-- 查看预约后的书籍状态和预约次数
SELECT bstatus, reserve_Times FROM Book WHERE bid = 'B012';

-- 取消预约记录
DELETE FROM Reserve WHERE book_ID = 'B012' AND reader_ID = 'R001';

-- 查看取消预约后的书籍状态和预约次数
SELECT bstatus, reserve_Times FROM Book WHERE bid = 'B012';
