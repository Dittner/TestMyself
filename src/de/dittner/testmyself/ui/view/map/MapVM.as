package de.dittner.testmyself.ui.view.map {
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

public class MapVM extends ViewModel {
	public function MapVM() {
		super();
	}

	public var selectedLang:Language;

	override protected function activate():void {}

	override public function viewActivated(viewInfo:ViewInfo):void {
		super.viewActivated(viewInfo);
		selectedLang = appModel.selectedLanguage;
	}

	override protected function deactivate():void {}
}
}