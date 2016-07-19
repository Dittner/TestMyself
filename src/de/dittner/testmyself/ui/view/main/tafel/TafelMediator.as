package de.dittner.testmyself.ui.view.main.tafel {
import de.dittner.testmyself.backend.LocalStorage;

import spark.events.TextOperationEvent;

public class TafelMediator extends SFMediator {

	[Inject]
	public var view:CommentsBoard;

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