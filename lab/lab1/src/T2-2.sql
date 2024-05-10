use lab1;

SELECT r.rid, r.rname
FROM reader r
LEFT JOIN borrow b ON r.rid = b.reader_ID
LEFT JOIN reserve res ON r.rid = res.reader_ID
WHERE b.reader_ID IS NULL AND res.reader_ID IS NULL;
