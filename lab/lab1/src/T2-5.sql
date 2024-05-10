-- 查询借阅图书数目（多次借同一本书需重复计入）超过 3 本的读者姓名
use lab1;

SELECT r.rname
FROM reader r
JOIN borrow br ON r.rid = br.reader_ID
GROUP BY r.rid
HAVING COUNT(br.book_ID) > 3;
