package dittner.testmyself.view.phrase.toolbar {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.PhraseVo;
import dittner.testmyself.view.common.mediator.RequestOperationMessage;
import dittner.testmyself.view.common.mediator.SmartMediator;
import dittner.testmyself.view.common.toobar.ToolAction;

import flash.events.Event;
import flash.events.MouseEvent;

public class PhraseToolbarMediator extends SmartMediator {

	[Inject]
	public var view:PhraseToolbar;

	override protected function onRegister():void {
		view.editBtn.enabled = false;
		view.removeBtn.enabled = false;

		addListeners();
		requestData(PhraseMsg.GET_SELECTED_PHRASE, new RequestOperationMessage(phraseSelectedHandler));
		addHandler(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, phraseSelectedHandler);
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

	private function phraseSelectedHandler(phrase:PhraseVo):void {
		if (phrase != PhraseVo.NULL) {
			view.editBtn.enabled = true;
			view.removeBtn.enabled = true;
		}
		else {
			view.editBtn.enabled = false;
			view.removeBtn.enabled = false;
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