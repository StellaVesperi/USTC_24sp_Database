/* 创建一个读者借书信息的视图，该视图包含读者号、姓名、所借图书号、图书名和借期
（对于没有借过图书的读者，是否包含在该视图中均可）；
并使用该视图查询2024年所有读者的读者号以及所借阅的不同图书数 */

use lab1;

CREATE VIEW BorrowView AS
SELECT r.rid, r.rname, b.bid, b.bname, br.borrow_Date
FROM borrow br
JOIN book b ON br.book_ID = b.bid
JOIN reader r ON br.reader_ID = r.rid;

SELECT rid, COUNT(DISTINCT bid) AS books_borrowed
FROM BorrowView
WHERE YEAR(borrow_Date) = 2024
GROUP BY rid;


