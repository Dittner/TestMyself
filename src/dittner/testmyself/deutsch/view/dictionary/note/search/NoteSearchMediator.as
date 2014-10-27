package dittner.testmyself.deutsch.view.dictionary.note.search {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexEvent;

public class NoteSearchMediator extends SFMediator {

	[Inject]
	public var view:SearchFilter;

	private var isActive:Boolean = false;
	private var filter:NoteFilter;

	override protected function activate():void {
		addListener(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
	}

	private function toolActionSelectedHandler(toolAction:String):void {
		if (!isActive && toolAction == ToolAction.SEARCH) {
			isActive = true;
			openDropdown();
			loadFilter();
		}
	}

	private function openDropdown():void {
		view.visible = true;
		sendNotification(NoteMsg.FORM_ACTIVATED_NOTIFICATION);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.clearBtn.addEventListener(MouseEvent.CLICK, clearHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
		view.searchInput.addEventListener(FlexEvent.ENTER, applyHandler);
	}

	private function clearHandler(event:MouseEvent):void {
		view.searchInput.text = "";
		updateFilter();
		closeDropdown();
	}

	private function cancelHandler(event:MouseEvent):void {
		closeDropdown();
	}

	private function closeDropdown():void {
		if (isActive) {
			view.visible = false;
			isActive = false;
			sendNotification(NoteMsg.FORM_DEACTIVATED_NOTIFICATION);
			view.clearBtn.removeEventListener(MouseEvent.CLICK, clearHandler);
			view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
			view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
			view.searchInput.removeEventListener(FlexEvent.ENTER, applyHandler);
		}
	}

	private function applyHandler(event:Event):void {
		updateFilter();
		closeDropdown();
	}

	private function updateFilter():void {
		if (!filter || filter.searchText == view.searchInput.text) return;
		filter.searchText = view.searchInput.text;
		filter.searchFullIdentity = view.fullIdentityBox.selected;
		sendRequest(NoteMsg.SET_FILTER, new RequestMessage(null, null, filter));
	}

	private function loadFilter():void {
		sendRequest(NoteMsg.GET_FILTER, new RequestMessage(onFilterLoaded));
	}

	private function onFilterLoaded(res:CommandResult):void {
		filter = res.data as NoteFilter;
		view.searchInput.text = filter.searchText;
		view.fullIdentityBox.selected = filter.searchFullIdentity;
	}

	override protected function deactivate():void {
		closeDropdown();
		filter = null;
	}

}
}
