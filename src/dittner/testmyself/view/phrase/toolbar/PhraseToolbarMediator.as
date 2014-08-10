package dittner.testmyself.view.phrase.toolbar {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.IPhrase;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.toobar.ToolAction;

import flash.events.Event;
import flash.events.MouseEvent;

public class PhraseToolbarMediator extends RequestMediator {

	[Inject]
	public var view:PhraseToolbar;

	override protected function onRegister():void {
		view.editBtn.enabled = false;
		view.removeBtn.enabled = false;

		addListeners();
		sendRequest(PhraseMsg.GET_SELECTED_PHRASE, new RequestMessage(phraseSelectedHandler));
		addHandler(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, phraseSelectedNotificationHandler);
	}

	private function addListeners():void {
		view.addBtn.addEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.editBtn.addEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.removeBtn.addEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.filterBtn.addEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.transInvertBtn.addEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.verLayoutBtn.addEventListener(Event.CHANGE, viewControlClickHandler);
		view.hideDetailsBtn.addEventListener(Event.CHANGE, viewControlClickHandler);
	}

	private function viewControlClickHandler(event:Event):void {
		var selectedAction:String;
		switch (event.target) {
			case(view.addBtn) :
				selectedAction = ToolAction.ADD;
				break;
			case(view.editBtn) :
				selectedAction = ToolAction.EDIT;
				break;
			case(view.removeBtn) :
				selectedAction = ToolAction.REMOVE;
				break;
			case(view.filterBtn) :
				selectedAction = ToolAction.FILTER;
				break;
			case(view.transInvertBtn) :
				selectedAction = ToolAction.TRANS_INVERT;
				break;
			case(view.verLayoutBtn) :
				selectedAction = view.verLayoutBtn.selected ? ToolAction.VER_LAYOUT : ToolAction.HOR_LAYOUT;
				break;
			case(view.hideDetailsBtn) :
				selectedAction = view.hideDetailsBtn.selected ? ToolAction.HIDE_DETAILS : ToolAction.SHOW_DETAILS;
				break;
		}
		if (selectedAction)
			sendMessage(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, selectedAction);
	}

	private function phraseSelectedHandler(res:CommandResult):void {
		phraseSelectedNotificationHandler(res.data as IPhrase);
	}

	private function phraseSelectedNotificationHandler(vo:IPhrase):void {
		if (vo == Phrase.NULL) {
			view.editBtn.enabled = false;
			view.removeBtn.enabled = false;
		}
		else {
			view.editBtn.enabled = true;
			view.removeBtn.enabled = true;
		}
	}

	override protected function onRemove():void {
		removeListeners();
		removeAllHandlers();
	}

	private function removeListeners():void {
		view.addBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.editBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.removeBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.filterBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.transInvertBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.verLayoutBtn.removeEventListener(Event.CHANGE, viewControlClickHandler);
		view.hideDetailsBtn.removeEventListener(Event.CHANGE, viewControlClickHandler);
	}

}
}