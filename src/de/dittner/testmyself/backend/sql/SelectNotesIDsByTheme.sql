SELECT id
FROM note
WHERE id
IN
(SELECT n.id FROM note n, filter f
WHERE n.id = f.noteID
AND f.themeID = :themeID)