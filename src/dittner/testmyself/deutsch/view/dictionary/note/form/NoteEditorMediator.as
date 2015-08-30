package dittner.testmyself.deutsch.view.dictionary.note.form {
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;
import dittner.testmyself.deutsch.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class NoteEditorMediator extends NoteFormMediator {

	override protected function toolActionSelectedHandler(toolAction:String):void {
		super.toolActionSelectedHandler(toolAction);
		if (!isActive && toolAction == ToolAction.EDIT && selectedNote) {
			isActive = true;
			view.edit(selectedNote);
			view.title = ToolActionName.getNameById(ToolAction.EDIT);
			openForm();
			loadThemes();
			loadExamples();
		}
	}

	override protected function onThemesLoaded(op:IAsyncOperation):void {
		super.onThemesLoaded(op);
		sendRequest(NoteMsg.GET_SELECTED_THEMES_ID, new RequestMessage(onSelectedThemesIDLoaded, selectedNote));
	}

	private function onSelectedThemesIDLoaded(op:IAsyncOperation):void {
		var themesID:Array = op.result as Array;
		if (view.themes && themesID && view.themes.length > 0 && themesID.length > 0) {
			var isSelectedThemeHash:Object = {};
			var selectedItems:Vector.<Object> = new Vector.<Object>();
			for each(var id:int in themesID) isSelectedThemeHash[id] = true;
			for each(var theme:ITheme in view.themes)
				if (isSelectedThemeHash[theme.id]) selectedItems.push(theme);
			view.themesList.selectedItems = selectedItems;
		}
	}

	override protected function applyHandler(event:MouseEvent):void {
		var errMsg:String;
		var suite:NoteSuite = new NoteSuite();

		suite.note = createNote();
		suite.origin = selectedNote;
		suite.note.id = selectedNote.id;
		errMsg = validateNote(suite.note);
		if (errMsg) {
			view.notifyInvalidData(errMsg);
			return;
		}

		suite.themes = createThemes();
		errMsg = validateThemes(suite.themes);
		if (errMsg) {
			view.notifyInvalidData(errMsg);
			return;
		}

		suite.examples = createExamples();
		errMsg = validateExamples(suite.examples);
		if (errMsg) {
			view.notifyInvalidData(errMsg);
			return;
		}

		send(suite);
	}

	override protected function send(suite:NoteSuite):void {
		sendRequest(NoteMsg.UPDATE_NOTE, new RequestMessage(updateNoteCompleteHandler, suite));
	}

	protected function updateNoteCompleteHandler(op:IAsyncOperation):void {
		if (op.isSuccess) closeForm();
		else view.notifyInvalidData(op.error.details);
	}

	protected function loadExamples():void {
		if (selectedNote) {
			sendRequest(NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, selectedNote.id));
		}
	}

	protected function onExamplesLoaded(op:IAsyncOperation):void {
		view.examplesForm.examples = new ArrayCollection(op.result as Array || []);
	}
}
}