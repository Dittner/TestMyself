SELECT *
FROM theme
WHERE vocabularyID = :vocabularyID
AND id
IN
(
   SELECT themeID FROM filter
   WHERE noteID = :selectedNoteID
)