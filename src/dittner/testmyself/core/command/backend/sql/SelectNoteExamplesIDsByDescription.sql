SELECT id
FROM example
WHERE description LIKE :searchFilter
ORDER BY id DESC