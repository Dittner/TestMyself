package de.dittner.testmyself.ui.view.noteList {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.NotePage;
import de.dittner.testmyself.ui.common.view.NoteFormViewInfo;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.ui.view.form.components.FormMode;
import de.dittner.testmyself.ui.view.form.components.FormOperationResult;

import flash.events.Event;

public class NoteListVM extends ViewModel {

	public function NoteListVM() {
		super();
	}

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
		switch (viewInfo.viewID) {
			case ViewID.WORD_LIST :
				setPage(appModel.getWordPage());
				break;
			case ViewID.VERB_LIST :
				setPage(appModel.getVerbPage());
				break;
			case ViewID.LESSON_LIST :
				setPage(appModel.getLessonPage());
				break;
			default :
				throw new Error("Unsupported VM for view with ID = " + viewInfo.viewID);
				break;
		}
		reloadPage();
	}

	public function reloadPage():void {
		if (page) page.load();
	}

	public function showNote(selectedNoteIndex:int):void {
		if (page && selectedNoteIndex != -1) {
			var info:ViewInfo = new ViewInfo();
			info.viewID = ViewID.NOTE_VIEW;
			info.page = page;
			info.page.selectedItemIndex = selectedNoteIndex;
			mainVM.viewNavigator.navigate(info);
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
}
}