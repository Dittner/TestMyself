package dittner.testmyself.view.phrase.form {
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.IPhrase;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.theme.ITheme;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class PhraseEditorMediator extends PhraseFormMediator {

	private var selectedPhrase:IPhrase = Phrase.NULL;

	override protected function onRegister():void {
		super.onRegister();
		addHandler(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, phraseSelectedHandler);
	}

	override protected function toolActionSelectedHandler(toolAction:String):void {
		if (!isActive && toolAction == ToolAction.EDIT && selectedPhrase != Phrase.NULL) {
			isActive = true;
			form.edit(selectedPhrase.origin, selectedPhrase.translation, selectedPhrase.audioRecord);
			form.title = ToolActionName.getNameById(ToolAction.EDIT);
			openForm();
			loadThemes();
		}
	}

	override protected function onThemesLoaded(res:CommandResult):void {
		super.onThemesLoaded(res);
		sendRequest(PhraseMsg.GET_SELECTED_THEMES_ID, new RequestMessage(onSelectedThemesIDLoaded, null, selectedPhrase));
	}

	private function onSelectedThemesIDLoaded(res:CommandResult):void {
		var themesID:Array = res.data as Array;
		if (form.themes && themesID && form.themes.length > 0 && themesID.length > 0) {
			var isSelectedThemeHash:Object = {};
			var selectedItems:Vector.<Object> = new Vector.<Object>();
			for each(var id:int in themesID) isSelectedThemeHash[id] = true;
			for each(var theme:ITheme in form.themes)
				if (isSelectedThemeHash[theme.id]) selectedItems.push(theme);
			form.themesList.selectedItems = selectedItems;
		}
	}

	private function phraseSelectedHandler(vo:Phrase):void {
		selectedPhrase = vo;
		if (isActive) throw new Error("Should not select new phrase when the old one is editing!")
	}

	override protected function applyHandler(event:MouseEvent):void {
		sendUpdatePhraseRequest();
	}

	private function sendUpdatePhraseRequest():void {
		var suite:Object = {};
		suite.phrase = createPhrase();
		suite.phrase.id = selectedPhrase.id;
		suite.themes = getSelectedThemes();
		sendRequest(PhraseMsg.UPDATE_PHRASE, new RequestMessage(updatePhraseCompleteHandler, updatePhraseErrorHandler, suite));
	}

	private function updatePhraseCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	private function updatePhraseErrorHandler(exc:CommandException):void {
		form.notifyInvalidData(exc.details);
	}
}
}