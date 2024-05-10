call returnBook('R001', 'B001', @return_info);
SELECT @return_info AS 'Test 2 Result';
-- 检查借阅记录的更新
SELECT return_Date FROM Borrow WHERE book_ID = 'B001' AND reader_ID = 'R001';
-- 检查书籍状态的更新
SELECT bstatus FROM Book WHERE bid = 'B001';