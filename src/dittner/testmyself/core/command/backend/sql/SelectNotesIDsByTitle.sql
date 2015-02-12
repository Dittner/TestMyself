SELECT id
FROM note
WHERE title LIKE :searchFilter
ORDER BY id DESC