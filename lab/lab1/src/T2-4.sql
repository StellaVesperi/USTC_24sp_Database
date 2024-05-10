use lab1;

SELECT b.bid, b.bname
FROM book b
JOIN borrow br ON b.bid = br.book_ID
WHERE br.return_Date IS NULL AND b.bname LIKE '%MySQL%';
