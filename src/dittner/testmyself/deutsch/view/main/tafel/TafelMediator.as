package dittner.testmyself.deutsch.view.main.tafel {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.testmyself.deutsch.utils.SharedObjectStorage;

import spark.events.TextOperationEvent;

public class TafelMediator extends SFMediator {

	[Inject]
	public var view:Tafel;

	private var localStorage:SharedObjectStorage;

	override protected function activate():void {
		localStorage = new SharedObjectStorage();
		localStorage.init("tafel");
		view.textArea.text = localStorage.getField("text") || "Hier sind Ihre Notizen";
		view.textArea.addEventListener(TextOperationEvent.CHANGE, textAreaChangeHandler);
	}

	private function textAreaChangeHandler(event:TextOperationEvent):void {
		localStorage.writeField("text", view.textArea.text);
	}

	override protected function deactivate():void {
		view.textArea.removeEventListener(TextOperationEvent.CHANGE, textAreaChangeHandler);
	}
}
}