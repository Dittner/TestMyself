package dittner.testmyself.deutsch.view.dictionary.note.form {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.message.RequestMessage;
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

	override protected function onThemesLoaded(res:CommandResult):void {
		super.onThemesLoaded(res);
		sendRequest(NoteMsg.GET_SELECTED_THEMES_ID, new RequestMessage(onSelectedThemesIDLoaded, null, selectedNote));
	}

	private function onSelectedThemesIDLoaded(res:CommandResult):void {
		var themesID:Array = res.data as Array;
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
		sendRequest(NoteMsg.UPDATE_NOTE, new RequestMessage(updateNoteCompleteHandler, updateNoteErrorHandler, suite));
	}

	protected function updateNoteCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	protected function updateNoteErrorHandler(exc:CommandException):void {
		view.notifyInvalidData(exc.details);
	}

	private function loadExamples():void {
		if (selectedNote) {
			sendRequest(NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, null, selectedNote.id));
		}
	}

	protected function onExamplesLoaded(res:CommandResult):void {
		view.examplesForm.examples = new ArrayCollection(res.data as Array || []);
	}
}
}