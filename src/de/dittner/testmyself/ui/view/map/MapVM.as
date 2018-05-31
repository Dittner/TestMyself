package de.dittner.testmyself.ui.view.map {
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

public class MapVM extends ViewModel {
	public function MapVM() {
		super();
	}

	public var lang:Language;

	override protected function activate():void {}

	override public function viewActivated(viewInfo:ViewInfo):void {
		super.viewActivated(viewInfo);
		lang = appModel.lang;
	}

	override protected function deactivate():void {}
}
}