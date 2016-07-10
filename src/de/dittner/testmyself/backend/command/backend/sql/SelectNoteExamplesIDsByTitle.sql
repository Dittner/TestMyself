SELECT id
FROM example
WHERE title LIKE :searchFilter1 OR title LIKE :searchFilter2
ORDER BY id DESC