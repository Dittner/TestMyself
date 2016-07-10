package de.dittner.testmyself.ui.view.main.tafel {
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.testmyself.backend.LocalStorage;

import spark.events.TextOperationEvent;

public class TafelMediator extends SFMediator {

	[Inject]
	public var view:Tafel;
	private static const TAFEL_TEXT_KEY:String = "TAFEL_TEXT_KEY";

	override protected function activate():void {
		view.textArea.text = LocalStorage.read(TAFEL_TEXT_KEY) || "Hier sind Ihre Notizen";
		view.textArea.addEventListener(TextOperationEvent.CHANGE, textAreaChangeHandler);
	}

	private function textAreaChangeHandler(event:TextOperationEvent):void {
		LocalStorage.write(TAFEL_TEXT_KEY, view.textArea.text);
	}

	override protected function deactivate():void {
		view.textArea.removeEventListener(TextOperationEvent.CHANGE, textAreaChangeHandler);
	}
}
}