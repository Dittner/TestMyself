package de.dittner.testmyself.model {
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.language.GermanLang;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.settings.SettingsModel;
import de.dittner.testmyself.ui.common.view.ViewFactory;
import de.dittner.testmyself.ui.common.view.ViewID;
import de.dittner.testmyself.ui.common.view.ViewNavigator;
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.walter.Walter;

import flash.events.Event;

public class AppModel extends Walter {
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
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var initialized:Boolean = false;
	public function init():void {
		if (initialized) return;
		initialized = true;

		selectedLanguage = new GermanLang();

		var viewNavigator:ViewNavigator = new ViewNavigator();
		registerProxy("viewNavigator", viewNavigator);
		registerProxy("viewFactory", new ViewFactory());
		registerProxy("mainVM", new MainVM());
		registerProxy("sqlStorage", new SQLStorage);
		registerProxy("settingsModel", new SettingsModel);
		registerProxy("viewMediatorFactory", new ViewMediatorFactory());
		registerProxy("encryptionService", new EncryptionService);
		registerProxy("system", new SiegmarFileSystem());
		registerProxy("user", new User());

		viewNavigator.navigate(ViewID.WORD);

	}

}
}
