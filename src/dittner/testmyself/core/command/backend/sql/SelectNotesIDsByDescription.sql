SELECT id
FROM note
WHERE description LIKE :searchFilter
ORDER BY id DESC