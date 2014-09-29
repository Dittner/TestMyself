package dittner.testmyself.deutsch.view.dictionary.note.list {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.page.INotePageInfo;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;
import dittner.testmyself.deutsch.view.dictionary.common.PageLayoutInfo;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class NoteListMediator extends SFMediator {

	[Inject]
	public var view:NoteList;

	private var pageLayoutInfo:PageLayoutInfo;

	override protected function activate():void {
		pageLayoutInfo = new PageLayoutInfo();
		view.addEventListener(SelectableDataGroup.SELECTED, noteRenDataSelectedHandler);
		addListener(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
		addListener(NoteMsg.NOTE_PAGE_INFO_CHANGED_NOTIFICATION, onPageInfoChanged);
		sendRequest(NoteMsg.GET_NOTE_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
	}

	private function noteRenDataSelectedHandler(event:Event):void {
		var selectedNoteRenData:NoteRendererData = view.selectedItem as NoteRendererData;
		var selectedNote:INote = selectedNoteRenData ? selectedNoteRenData.note : null;
		sendRequest(NoteMsg.SELECT_NOTE, new RequestMessage(null, null, selectedNote));
	}

	private function onPageInfoChanged(pageInfo:INotePageInfo):void {
		updateViewList(pageInfo);
	}

	private function onPageInfoLoaded(res:CommandResult):void {
		updateViewList(res.data as INotePageInfo);
	}

	private function updateViewList(pageInfo:INotePageInfo):void {
		view.dataProvider = new ArrayCollection(wrapNotes(pageInfo.notes));
		sendRequest(NoteMsg.SELECT_NOTE, new RequestMessage());
	}

	private function wrapNotes(notes:Array):Array {
		var items:Array = [];
		var item:NoteRendererData;
		for each(var vo:INote in notes) {
			item = new NoteRendererData(vo, pageLayoutInfo);
			items.push(item);
		}
		return items;
	}

	private function toolActionSelectedHandler(toolId:String):void {
		switch (toolId) {
			case(ToolAction.INVERT) :
				pageLayoutInfo.inverted = !pageLayoutInfo.inverted;
				break;
			case(ToolAction.HOR_LAYOUT) :
				pageLayoutInfo.isHorizontal = true;
				break;
			case(ToolAction.VER_LAYOUT) :
				pageLayoutInfo.isHorizontal = false;
				break;
			case(ToolAction.HIDE_DETAILS) :
				pageLayoutInfo.showDetails = false;
				break;
			case(ToolAction.SHOW_DETAILS) :
				pageLayoutInfo.showDetails = true;
				break;
		}
		view.invalidateLayout();
	}

	override protected function deactivate():void {
		view.removeEventListener(SelectableDataGroup.SELECTED, noteRenDataSelectedHandler);
		view.dataProvider = null;
		sendRequest(NoteMsg.SELECT_NOTE, new RequestMessage());
		pageLayoutInfo = null;
	}

}
}