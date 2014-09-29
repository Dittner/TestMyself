package dittner.testmyself.deutsch.view.dictionary.note.form {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteHash;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.deutsch.message.SettingsMsg;
import dittner.testmyself.deutsch.model.settings.SettingsInfo;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

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

	//abstract
	protected function toolActionSelectedHandler(toolAction:String):void {}

	private function noteSelectedHandler(vo:Note):void {
		selectedNote = vo;
		if (isActive) throw new Error("Should not select new note when the old one is editing!")
	}

	protected function loadThemes():void {
		sendRequest(NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
	}

	protected function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		view.themes = new ArrayCollection(themeItems);
	}

	private function infoLoaded(res:CommandResult):void {
		var info:SettingsInfo = res.data as SettingsInfo;
		view.audioRecorder.maxRecordSize = info.maxAudioRecordDuration;
	}

	private function noteHashLoaded(res:CommandResult):void {
		noteHash = res.data as NoteHash;
	}

	protected function openForm():void {
		view.visible = true;
		sendNotification(NoteMsg.FORM_ACTIVATED_NOTIFICATION);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
		view.addThemeBtn.addEventListener(MouseEvent.CLICK, addThemeBtnClickHandler);
	}

	protected function cancelHandler(event:MouseEvent):void {
		closeForm();
	}

	protected function closeForm():void {
		view.visible = false;
		isActive = false;
		view.close();
		sendNotification(NoteMsg.FORM_DEACTIVATED_NOTIFICATION);
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
		view.addThemeBtn.removeEventListener(MouseEvent.CLICK, addThemeBtnClickHandler);
	}

	//abstract
	protected function applyHandler(event:MouseEvent):void {}

	//abstract
	protected function createNote():Note {return null;}

	//abstract
	protected function validateNote(note:Note):String {
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
			if (!theme.name) return "Название темы не должно быть пустым";
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
		for each(var note:INote in examples) {
			if (!note.title) return "В примере не должно быть пустого заголовка!";
		}
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
			view.notifyInvalidData('Не удалось добавить тему, так как тема с названием "' + addedThemeName + '" уже находится в списке!');
		}
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