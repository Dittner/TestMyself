SELECT id
FROM note
WHERE description LIKE :searchFilter1 OR description LIKE :searchFilter2
ORDER BY id DESC