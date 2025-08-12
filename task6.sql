-- Task 6: Subqueries and Nested Queries

-- 1. Scalar Subquery: Find the book with the highest price
SELECT title, price
FROM librarydb.Books
WHERE price = (SELECT MAX(price) FROM librarydb.Books);

-- 2. Multiple-row Subquery with IN: List members who borrowed any books published after 2018
SELECT name, email
FROM librarydb.Members
WHERE member_id IN (
    SELECT member_id
    FROM librarydb.BorrowedBooks bb
    JOIN librarydb.Books b ON bb.book_id = b.book_id
    WHERE b.year_published > 2018
);

-- 3. Correlated Subquery: List members who borrowed more than 1 book
SELECT m.name
FROM librarydb.Members m
WHERE (
    SELECT COUNT(*)
    FROM librarydb.BorrowedBooks bb
    WHERE bb.member_id = m.member_id
) > 1;

-- 4. Using EXISTS: Find members who have borrowed at least one book
SELECT name
FROM librarydb.Members m
WHERE EXISTS (
    SELECT 1
    FROM librarydb.BorrowedBooks bb
    WHERE bb.member_id = m.member_id
);

-- 5. Subquery in FROM clause: Average book price by year
SELECT year_published, AVG(price) AS avg_price
FROM (
    SELECT year_published, price
    FROM librarydb.Books
) AS sub
GROUP BY year_published;

-- 6. Nested Subquery: Find members who borrowed the most expensive book
SELECT DISTINCT m.name
FROM librarydb.Members m
JOIN librarydb.BorrowedBooks bb ON m.member_id = bb.member_id
WHERE bb.book_id IN (
    SELECT book_id
    FROM librarydb.Books
    WHERE price = (SELECT MAX(price) FROM librarydb.Books)
);
