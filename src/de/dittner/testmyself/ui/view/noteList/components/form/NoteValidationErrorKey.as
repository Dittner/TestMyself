package de.dittner.testmyself.ui.view.noteList.components.form {
import de.dittner.testmyself.model.domain.language.LanguageID;

import mx.resources.ResourceManager;

public class NoteValidationErrorKey {
	public function NoteValidationErrorKey() {}

	public static const EMPTY_TAG_NAME:String = "EMPTY_TAG_NAME";
	public static const TAG_NAME_DUPLICATE:String = "TAG_NAME_DUPLICATE";

	public static const EMPTY_NOTE_TITLE:String = "EMPTY_NOTE_TITLE";
	public static const EMPTY_NOTE_DESCRIPTION:String = "EMPTY_NOTE_DESCRIPTION";
	public static const NOTE_DUPLICATE:String = "NOTE_DUPLICATE";

	public static const EMPTY_EXAMPLE_TITLE:String = "EMPTY_EXAMPLE_TITLE";
	public static const EMPTY_EXAMPLE_DESCRIPTION:String = "EMPTY_EXAMPLE_DESCRIPTION";

	public static const EMPTY_VERB_FIELDS:String = "EMPTY_VERB_FIELDS";

	public static function keyToString(key:String, langID:uint):String {
		if (langID == LanguageID.DE) {
			switch (key) {
				case EMPTY_TAG_NAME :
					return ResourceManager.getInstance().getString('app', 'NameOfTagIsEmpty');
				case TAG_NAME_DUPLICATE :
					return ResourceManager.getInstance().getString('app', 'TagHasDuplicate');
				case EMPTY_NOTE_TITLE :
					return ResourceManager.getInstance().getString('app', 'TitleOfNoteIsEmpty');
				case EMPTY_NOTE_DESCRIPTION :
					return ResourceManager.getInstance().getString('app', 'TranslationOfNoteIsEmpty');
				case NOTE_DUPLICATE :
					return ResourceManager.getInstance().getString('app', 'NoteHasDuplicate');
				case EMPTY_EXAMPLE_TITLE :
					return ResourceManager.getInstance().getString('app', 'TitleOfExampleIsEmpty');
				case EMPTY_EXAMPLE_DESCRIPTION :
					return ResourceManager.getInstance().getString('app', 'TranslationOfExampleIsEmpty');
				case EMPTY_VERB_FIELDS :
					return ResourceManager.getInstance().getString('app', 'FormsOfVerbIsEmpty');
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
