SELECT *
FROM note
WHERE title LIKE :searchFilter
ORDER BY id DESC
LIMIT :startIndex, :amount