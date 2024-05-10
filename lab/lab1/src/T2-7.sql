-- 查询 2024 年借阅图书数目排名前 3 名的读者号、姓名以及借阅图书数

use lab1;

SELECT r.rid, r.rname, COUNT(br.book_ID) AS borrow_count
FROM borrow br
JOIN reader r ON br.reader_ID = r.rid
WHERE YEAR(br.borrow_Date) = 2024
GROUP BY r.rid
ORDER BY borrow_count DESC
LIMIT 3;
