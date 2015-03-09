SELECT id
FROM note
WHERE title LIKE :searchFilter1 OR title LIKE :searchFilter2
ORDER BY id DESC