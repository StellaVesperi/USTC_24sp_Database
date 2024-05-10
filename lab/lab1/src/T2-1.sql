use lab1;

SELECT b.bid, b.bname, br.borrow_Date
FROM book b
JOIN borrow br ON b.bid = br.book_ID
JOIN reader r ON br.reader_ID = r.rid
WHERE r.rname = 'Rose';
