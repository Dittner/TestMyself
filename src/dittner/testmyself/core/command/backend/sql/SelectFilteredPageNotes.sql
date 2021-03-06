SELECT n.*
FROM note n, filter f, theme t
WHERE n.id = f.noteID
AND n.title LIKE :searchFilter
AND f.themeID = t.id
AND t.name
IN #filterList
ORDER BY n.id DESC
LIMIT :startIndex, :amount