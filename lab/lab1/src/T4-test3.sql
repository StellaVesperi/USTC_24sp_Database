CALL borrowBook('R001', 'B001', @return_info);
SELECT @return_info AS 'Test 3 Result';
-- 已预约过相同的书
