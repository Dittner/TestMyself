SELECT COUNT(ph.id) FROM phrase ph, phraseFilter f, phraseTheme t
WHERE ph.id = f.phraseID
AND f.themeID = t.id
AND t.name
IN #filterList