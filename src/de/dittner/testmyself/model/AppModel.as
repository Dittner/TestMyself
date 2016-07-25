package de.dittner.testmyself.model {
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.walter.WalterProxy;

import flash.events.Event;

public class AppModel extends WalterProxy {
	private static const SELECTED_LANG_CHANGED_MSG:String = "SELECTED_LANG_CHANGED_MSG";
	private static const SELECTED_VOCABULARY_CHANGED_MSG:String = "SELECTED_VOCABULARY_CHANGED_MSG";

	public function AppModel() {
		super();
	}

	//--------------------------------------
	//  selectedLanguage
	//--------------------------------------
	private var _selectedLanguage:Language;
	[Bindable("selectedLanguageChanged")]
	public function get selectedLanguage():Language {return _selectedLanguage;}
	public function set selectedLanguage(value:Language):void {
		if (_selectedLanguage != value) {
			_selectedLanguage = value;
			dispatchEvent(new Event("selectedLanguageChanged"));
			sendMessage(SELECTED_LANG_CHANGED_MSG, selectedLanguage);
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

}
}
