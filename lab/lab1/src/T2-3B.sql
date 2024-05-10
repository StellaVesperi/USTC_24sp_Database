use lab1;
-- 方法b
SELECT author
FROM book
GROUP BY author
ORDER BY SUM(borrow_times) DESC
LIMIT 1;
