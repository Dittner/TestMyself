SELECT id, origin, translation, audioRecord
FROM phrase
ORDER BY id DESC
LIMIT :startIndex, :amount