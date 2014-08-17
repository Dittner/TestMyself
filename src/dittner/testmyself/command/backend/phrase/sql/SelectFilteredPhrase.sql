SELECT ph.id, ph.origin, ph.translation, ph.audioRecord
FROM phrase ph, phraseFilter f, phraseTheme t
WHERE ph.id = f.phraseID
AND f.themeID = t.id
AND t.name
IN #filterList
ORDER BY ph.id DESC
LIMIT :startIndex, :amount