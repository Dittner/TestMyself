package de.dittner.testmyself.ui.view.dictionary.note.toolbar {
import de.dittner.async.IAsyncOperation;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.ui.common.toobar.ToolAction;

import flash.events.Event;
import flash.events.MouseEvent;

public class NoteToolbarMediator extends SFMediator {

	[Inject]
	public var view:NoteToolbar;

	override protected function activate():void {
		view.editBtn.enabled = false;
		view.removeBtn.enabled = false;

		addToolbarListeners();
		sendRequest(NoteMsg.GET_SELECTED_NOTE, new RequestMessage(noteSelectedHandler));
		addListener(NoteMsg.NOTE_SELECTED_NOTIFICATION, noteSelectedNotificationHandler);
	}

	private function addToolbarListeners():void {
		view.addBtn.addEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.editBtn.addEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.removeBtn.addEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.searchBtn.addEventListener(MouseEvent.CLICK, viewControlClickHandler);
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
			case(view.searchBtn) :
				selectedAction = ToolAction.SEARCH;
				break;
			case(view.filterBtn) :
				selectedAction = ToolAction.FILTER;
				break;
			case(view.transInvertBtn) :
				selectedAction = ToolAction.INVERT;
				break;
			case(view.verLayoutBtn) :
				selectedAction = view.verLayoutBtn.selected ? ToolAction.VER_LAYOUT : ToolAction.HOR_LAYOUT;
				break;
			case(view.hideDetailsBtn) :
				selectedAction = view.hideDetailsBtn.selected ? ToolAction.HIDE_DETAILS : ToolAction.SHOW_DETAILS;
				break;
		}
		if (selectedAction)
			sendNotification(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, selectedAction);
	}

	private function noteSelectedHandler(op:IAsyncOperation):void {
		noteSelectedNotificationHandler(op.result as INote);
	}

	private function noteSelectedNotificationHandler(vo:INote):void {
		view.editBtn.enabled = vo != null;
		view.removeBtn.enabled = vo != null;
	}

	override protected function deactivate():void {
		removeToolbarListeners();
	}

	private function removeToolbarListeners():void {
		view.addBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.editBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.removeBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.searchBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.filterBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.transInvertBtn.removeEventListener(MouseEvent.CLICK, viewControlClickHandler);
		view.verLayoutBtn.removeEventListener(Event.CHANGE, viewControlClickHandler);
		view.hideDetailsBtn.removeEventListener(Event.CHANGE, viewControlClickHandler);
	}

}
}