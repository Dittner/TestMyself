SELECT id
FROM example
WHERE description LIKE :searchFilter1 OR description LIKE :searchFilter2 OR title LIKE :searchFilter1 OR title LIKE :searchFilter2
ORDER BY id DESC