SELECT u.*
FROM transUnit u, filter f, theme t
WHERE u.id = f.transUnitID
AND f.themeID = t.id
AND t.name
IN #filterList
ORDER BY u.id DESC
LIMIT :startIndex, :amount