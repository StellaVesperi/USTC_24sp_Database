-- 查询没有借阅过任何一本 J.K. Rowling 所著的图书的读者号和姓名
use lab1;

SELECT r.rid, r.rname
FROM reader r
WHERE NOT EXISTS (
    SELECT 1
    FROM borrow br
    JOIN book b ON br.book_ID = b.bid
    WHERE b.author = 'J.K. Rowling' AND br.reader_ID = r.rid
);
