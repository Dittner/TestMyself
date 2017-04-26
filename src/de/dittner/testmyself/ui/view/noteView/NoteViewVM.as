package de.dittner.testmyself.ui.view.noteView {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.NotePage;
import de.dittner.testmyself.ui.common.view.NoteFormViewInfo;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.ui.view.form.components.FormMode;
import de.dittner.testmyself.ui.view.form.components.FormOperationResult;

import flash.events.Event;

public class NoteViewVM extends ViewModel {

	public function NoteViewVM() {
		super();
	}

	[Inject]
	public var storage:Storage;

	[Bindable]
	public var selectedLang:Language;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  page
	//--------------------------------------
	private var _page:NotePage;
	[Bindable("pageChanged")]
	public function get page():NotePage {return _page;}
	private function setPage(value:NotePage):void {
		if (_page != value) {
			_page = value;
			dispatchEvent(new Event("pageChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(viewInfo:ViewInfo):void {
		super.viewActivated(viewInfo);
		setPage(viewInfo.page);
	}

	public function reloadPage():IAsyncOperation {
		return page.load();
	}

	public function showNextNote():void {
		if (page.coll && page.coll.length > 0) {
			if (page.selectedItemIndex < page.coll.length - 1) {
				page.selectedItemIndex++;
			}
			else if (page.number < page.totalPages - 1) {
				page.number++;
				reloadPage().addCompleteCallback(function (op:IAsyncOperation):void {
					page.selectedItemIndex = 0;
				});
			}
		}
	}

	public function showPrevNote():void {
		if (page && page.coll) {
			if (page.coll.length > 0 && page.selectedItemIndex > 0) {
				page.selectedItemIndex--;
			}
			else if (page.number > 0) {
				page.number--;
				reloadPage().addCompleteCallback(function (op:IAsyncOperation):void {
					page.selectedItemIndex = page.coll && page.coll.length > 0 ? page.coll.length - 1 : 0;
				});
			}
		}
	}

	public function createNote():void {
		var info:NoteFormViewInfo = new NoteFormViewInfo(ViewID.NOTE_FORM);
		info.note = page.vocabulary.createNote();
		info.filter = page.selectedTag;
		info.formMode = FormMode.ADD;
		info.callback = new AsyncOperation();
		info.callback.addCompleteCallback(noteAddedComplete);
		navigateTo(info);
	}

	private function noteAddedComplete(op:IAsyncOperation):void {
		if (op.isSuccess && op.result == FormOperationResult.OK) {
			if (page.selectedTag) page.countAllNotes = true;
			else page.allNotesAmount++;
			reloadPage();
		}
	}

	public function editNote():void {
		var info:NoteFormViewInfo = new NoteFormViewInfo(ViewID.NOTE_FORM);
		info.note = page.selectedNote;
		info.filter = page.selectedTag;
		info.formMode = FormMode.EDIT;
		info.callback = new AsyncOperation();
		info.callback.addCompleteCallback(noteEditComplete);
		navigateTo(info);
	}

	private function noteEditComplete(op:IAsyncOperation):void {
		if (op.isSuccess && op.result == FormOperationResult.OK) {
			page.countAllNotes = true;
			reloadPage();
		}
	}

	public function removeNote():void {
		var info:NoteFormViewInfo = new NoteFormViewInfo(ViewID.NOTE_FORM);
		info.note = page.selectedNote;
		info.filter = page.selectedTag;
		info.formMode = FormMode.REMOVE;
		info.callback = new AsyncOperation();
		info.callback.addCompleteCallback(noteRemovedComplete);
		navigateTo(info);
	}

	private function noteRemovedComplete(op:IAsyncOperation):void {
		if (op.isSuccess && op.result == FormOperationResult.OK) {
			page.countAllNotes = true;
			if (page.selectedItemIndex == 0)
				showPrevNote();
			else
				reloadPage();
		}
	}

}
}