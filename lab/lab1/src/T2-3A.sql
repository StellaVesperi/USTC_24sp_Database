use lab1;
-- 方法a
SELECT b.author
FROM book b
JOIN borrow br ON b.bid = br.book_ID
GROUP BY b.author
ORDER BY COUNT(br.book_ID) DESC
LIMIT 1;
