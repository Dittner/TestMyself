package de.dittner.testmyself.ui.view.map {
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.ui.common.view.ViewModel;

public class MapVM extends ViewModel {
	public function MapVM() {
		super();
	}

	public var selectedLang:Language;

	override protected function activate():void {}

	override public function viewActivated(viewID:String):void {
		super.viewActivated(viewID);
		selectedLang = appModel.selectedLanguage;
	}

	override protected function deactivate():void {}
}
}