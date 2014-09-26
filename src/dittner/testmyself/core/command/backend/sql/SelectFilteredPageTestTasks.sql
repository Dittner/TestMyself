SELECT t.*
FROM note n, filter f, theme th, test t
WHERE t.testID = :selectedTestID
AND t.noteID = n.id
AND n.id = f.noteID
AND f.themeID = th.id
AND th.name
IN #filterList
ORDER BY t.balance
LIMIT :startIndex, :amount