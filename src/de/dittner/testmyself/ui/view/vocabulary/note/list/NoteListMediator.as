package de.dittner.testmyself.ui.view.vocabulary.note.list {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.page.INotePageRequest;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;
import de.dittner.testmyself.ui.common.toobar.ToolAction;
import de.dittner.testmyself.ui.view.vocabulary.common.PageLayoutInfo;

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
		sendRequest(NoteMsg.SELECT_NOTE, new RequestMessage(null, selectedNote));
	}

	private function onPageInfoChanged(pageInfo:INotePageRequest):void {
		updateViewList(pageInfo);
	}

	private function onPageInfoLoaded(op:IAsyncOperation):void {
		updateViewList(op.result as INotePageRequest);
	}

	private function updateViewList(pageInfo:INotePageRequest):void {
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

	private function toolActionSelectedHandler(toolID:String):void {
		switch (toolID) {
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