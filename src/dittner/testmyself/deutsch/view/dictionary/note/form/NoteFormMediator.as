package dittner.testmyself.deutsch.view.dictionary.note.form {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteHash;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.message.SettingsMsg;
import dittner.testmyself.deutsch.model.settings.SettingsInfo;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

import spark.events.TextOperationEvent;

public class NoteFormMediator extends SFMediator {

	[Inject]
	public var view:NoteForm;

	protected var isActive:Boolean = false;
	protected var selectedNote:Note;
	protected var noteHash:NoteHash;

	override protected function activate():void {
		addListener(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
		addListener(NoteMsg.NOTE_SELECTED_NOTIFICATION, noteSelectedHandler);
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded));
		sendRequest(NoteMsg.GET_NOTE_HASH, new RequestMessage(noteHashLoaded));
	}

	protected function toolActionSelectedHandler(toolAction:String):void {
		if (isActive) return;
		switch (toolAction) {
			case ToolAction.ADD:
			case ToolAction.EDIT:
			case ToolAction.REMOVE:
				sendRequest(ScreenMsg.EDIT, new RequestMessage(null, true));
				break;
		}
	}

	private function noteSelectedHandler(vo:Note):void {
		selectedNote = vo;
		if (selectedNote && isActive) throw new Error("Should not select new note when the old one is editing!")
	}

	protected function loadThemes():void {
		sendRequest(NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
	}

	protected function onThemesLoaded(op:IAsyncOperation):void {
		var themeItems:Array = op.result as Array;
		view.themes = new ArrayCollection(themeItems);
	}

	private function infoLoaded(op:IAsyncOperation):void {
		var info:SettingsInfo = op.result as SettingsInfo;
		view.audioRecorder.maxRecordSize = info.maxAudioRecordDuration;
	}

	private function noteHashLoaded(op:IAsyncOperation):void {
		noteHash = op.result as NoteHash;
	}

	protected function openForm():void {
		view.visible = true;
		view.wordInput.isValidInput = true;
		view.titleArea.isValidInput = true;
		view.verbInputsForm.infinitiveInput.isValidInput = true;
		sendNotification(NoteMsg.FORM_ACTIVATED_NOTIFICATION);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
		view.addThemeBtn.addEventListener(MouseEvent.CLICK, addThemeBtnClickHandler);
		view.wordInput.addEventListener(TextOperationEvent.CHANGE, validateInputText);
		view.titleArea.addEventListener(TextOperationEvent.CHANGE, validateInputText);
		view.verbInputsForm.infinitiveInput.addEventListener(TextOperationEvent.CHANGE, validateInputText);
		view.articleBox.addEventListener(Event.CHANGE, validateInputText);
	}

	protected function cancelHandler(event:MouseEvent):void {
		closeForm();
	}

	protected function closeForm():void {
		sendRequest(ScreenMsg.EDIT, new RequestMessage(null, false));
		view.visible = false;
		isActive = false;
		view.close();
		sendNotification(NoteMsg.FORM_DEACTIVATED_NOTIFICATION);
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
		view.addThemeBtn.removeEventListener(MouseEvent.CLICK, addThemeBtnClickHandler);
		view.wordInput.removeEventListener(TextOperationEvent.CHANGE, validateInputText);
		view.titleArea.removeEventListener(TextOperationEvent.CHANGE, validateInputText);
		view.verbInputsForm.infinitiveInput.removeEventListener(TextOperationEvent.CHANGE, validateInputText);
		view.articleBox.removeEventListener(Event.CHANGE, validateInputText);
	}

	//abstract
	protected function applyHandler(event:MouseEvent):void {}

	//abstract
	protected function createNote():Note {return null;}

	//abstract
	protected function validateNote(note:Note):String {
		return "";
	}
	//abstract
	protected function validateDuplicateNote(note:Note):String {
		return "";
	}

	protected function createThemes():Array {
		var res:Array = [];
		for each(var theme:ITheme in view.themesList.selectedItems) res.push(theme);
		return res;
	}

	protected function validateThemes(themes:Array):String {
		if (!themes) {
			return "Отсутствует список тем, ожидается пустой или заполненный список"
		}
		for each(var theme:ITheme in themes) {
			if (!theme.name) return "Darf man den Namen des Themas nicht verpassen";
		}
		return "";
	}

	protected function createExamples():Array {
		var res:Array = [];
		for each(var note:INote in view.examplesForm.examples) res.push(note);
		return res;
	}

	protected function validateExamples(examples:Array):String {
		if (!examples) {
			return "Отсутствует список тем, ожидается пустой или заполненный список"
		}
		var errMsg:String = "";
		for each(var note:INote in examples) {
			errMsg = validateExample(note);
			if (errMsg) return errMsg;
		}
		return "";
	}

	protected function validateExample(example:INote):String {
		if (!example.title || !example.description) return "Die Form is nicht ergänzt: Deutschtext und Übersetzung darf man nicht verpassen!";
		return "";
	}

	//abstract
	protected function send(suite:NoteSuite):void {}

	//--------------------------------------
	//  Add theme
	//--------------------------------------

	private function addThemeBtnClickHandler(event:MouseEvent):void {
		if (!view.addThemeInput.text) return;

		var addedThemeName:String = view.addThemeInput.text;
		if (validateAddedTheme(addedThemeName)) {
			var vo:Theme = new Theme();
			vo.name = addedThemeName;
			view.themes.addItem(vo);
			var selectedItems:Vector.<Object> = view.themesList.selectedItems || new Vector.<Object>();
			selectedItems.push(vo);
			view.themesList.selectedItems = selectedItems;
			view.addThemeInput.text = "";
		}
		else {
			view.notifyInvalidData('Die Themenliste hat schon das gleiche Thema: "' + addedThemeName + '"!');
		}
	}

	private function validateInputText(event:*):void {
		var errMsg:String = validateDuplicateNote(createNote());
		view.wordInput.isValidInput = !errMsg;
		view.titleArea.isValidInput = !errMsg;
		view.verbInputsForm.infinitiveInput.isValidInput = !errMsg;
	}

	private function validateAddedTheme(themeName:String):Boolean {
		for each(var theme:ITheme in view.themes) {
			if (theme.name == themeName) return false;
		}
		return true;
	}

	override protected function deactivate():void {
		if (isActive) {
			isActive = false;
			closeForm();
		}
	}

}
}