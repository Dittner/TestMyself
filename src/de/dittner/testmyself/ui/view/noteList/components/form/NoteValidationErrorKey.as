package de.dittner.testmyself.ui.view.noteList.components.form {
import de.dittner.testmyself.model.domain.language.LanguageID;

public class NoteValidationErrorKey {
	public function NoteValidationErrorKey() {}

	public static const EMPTY_THEME_NAME:String = "EMPTY_THEME_NAME";
	public static const THEME_NAME_DUPLICATE:String = "THEME_NAME_DUPLICATE";

	public static const EMPTY_NOTE_TITLE:String = "EMPTY_NOTE_TITLE";
	public static const EMPTY_NOTE_DESCRIPTION:String = "EMPTY_NOTE_DESCRIPTION";
	public static const NOTE_DUPLICATE:String = "NOTE_DUPLICATE";

	public static const EMPTY_EXAMPLE_TITLE:String = "EMPTY_EXAMPLE_TITLE";
	public static const EMPTY_EXAMPLE_DESCRIPTION:String = "EMPTY_EXAMPLE_DESCRIPTION";

	public static const EMPTY_VERB_FIELDS:String = "EMPTY_VERB_FIELDS";

	public static function keyToString(key:String, langID:uint):String {
		if (langID == LanguageID.DE) {
			switch (key) {
				case EMPTY_THEME_NAME :
					return "Der Name des Themas is nicht ergänzt!";
				case THEME_NAME_DUPLICATE :
					return "Das Thema hat das Duplikat!";
				case EMPTY_NOTE_TITLE :
					return "Der Titel der Note is nicht ergänzt!";
				case EMPTY_NOTE_DESCRIPTION :
					return "Die Übersetzung der Note is nicht ergänzt!";
				case NOTE_DUPLICATE :
					return "Die Note hat das Duplikat!";
				case EMPTY_EXAMPLE_TITLE :
					return "Der Titel eines Beispiels is nicht ergänzt!";
				case EMPTY_EXAMPLE_DESCRIPTION :
					return "Die Übersetzung eines Beispiels is nicht ergänzt!";
				case EMPTY_VERB_FIELDS :
					return "Die Fielde 'Präsens', 'Präteritum' und 'Partizip II' müssen ergänzt sein!";
				default :
					return "Unknown Key : " + key;
			}
		}
		else {
			return "Unknown language";
		}
	}
}
}
