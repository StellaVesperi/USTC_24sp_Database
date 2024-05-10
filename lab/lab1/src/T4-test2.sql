CALL borrowBook('R001', 'B001', @return_info);
SELECT @return_info AS Return_Info;  -- 应显示 "ok"
SELECT * FROM Reserve WHERE book_ID = 'B001' AND reader_ID = 'R001';  -- 应显示为空
SELECT borrow_Times, bstatus FROM Book WHERE bid = 'B001';  -- 显示增加的借阅次数和状态变更
