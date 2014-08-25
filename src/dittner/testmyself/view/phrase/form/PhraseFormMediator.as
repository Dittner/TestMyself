package dittner.testmyself.view.phrase.form {
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.message.SettingsMsg;
import dittner.testmyself.model.phrase.IPhrase;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.settings.SettingsInfo;
import dittner.testmyself.model.theme.ITheme;
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class PhraseFormMediator extends RequestMediator {

	[Inject]
	public var form:PhraseForm;

	protected var isActive:Boolean = false;
	protected var selectedPhrase:IPhrase;

	override protected function onRegister():void {
		addHandler(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
		addHandler(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, phraseSelectedHandler);
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded))
	}

	//abstract
	protected function toolActionSelectedHandler(toolAction:String):void {}

	private function phraseSelectedHandler(vo:Phrase):void {
		selectedPhrase = vo;
		if (isActive) throw new Error("Should not select new phrase when the old one is editing!")
	}

	protected function loadThemes():void {
		sendRequest(PhraseMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
	}

	protected function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		form.themes = new ArrayCollection(themeItems);
	}

	private function infoLoaded(res:CommandResult):void {
		var info:SettingsInfo = res.data as SettingsInfo;
		form.audioRecorder.maxRecordSize = info.maxAudioRecordDuration;
	}

	protected function openForm():void {
		form.visible = true;
		sendMessage(PhraseMsg.FORM_ACTIVATED_NOTIFICATION);
		form.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		form.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
		form.addThemeBtn.addEventListener(MouseEvent.CLICK, addThemeBtnClickHandler);
	}

	protected function cancelHandler(event:MouseEvent):void {
		closeForm();
	}

	protected function closeForm():void {
		form.visible = false;
		isActive = false;
		form.close();
		sendMessage(PhraseMsg.FORM_DEACTIVATED_NOTIFICATION);
		form.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		form.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
		form.addThemeBtn.removeEventListener(MouseEvent.CLICK, addThemeBtnClickHandler);
	}

	//abstract
	protected function applyHandler(event:MouseEvent):void {}

	protected function createPhrase():Phrase {
		var phrase:Phrase = new Phrase();
		phrase.origin = form.originArea.text;
		phrase.translation = form.translationArea.text;
		phrase.audioRecord = hasAudio ? form.audioRecorder.recordedBytes : null;
		return phrase;
	}

	private function get hasAudio():Boolean {
		if (!form.audioRecorder.recordedBytes) return false;
		return form.audioRecorder.recordedBytes.length > 0;
	}

	protected function getSelectedThemes():Array {
		var res:Array = [];
		for each(var theme:ITheme in form.themesList.selectedItems) res.push(theme);
		return res;
	}

	//--------------------------------------
	//  Add theme
	//--------------------------------------

	private function addThemeBtnClickHandler(event:MouseEvent):void {
		if (!form.addThemeInput.text) return;

		var addedThemeName:String = form.addThemeInput.text;
		if (validateAddedTheme(addedThemeName)) {
			var vo:Theme = new Theme();
			vo.name = addedThemeName;
			form.themes.addItem(vo);
			var selectedItems:Vector.<Object> = form.themesList.selectedItems || new Vector.<Object>();
			selectedItems.push(vo);
			form.themesList.selectedItems = selectedItems;
			form.addThemeInput.text = "";
		}
		else {
			form.notifyInvalidData('Не удалось добавить тему, так как тема с названием "' + addedThemeName + '" уже находится в списке!');
		}
	}

	private function validateAddedTheme(themeName:String):Boolean {
		for each(var theme:ITheme in form.themes) {
			if (theme.name == themeName) return false;
		}
		return true;
	}

	override protected function onRemove():void {
		removeAllHandlers();
		if (isActive) {
			isActive = false;
			closeForm();
		}
	}

}
}