package dittner.testmyself.view.phrase.form {
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.IPhrase;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.theme.ITheme;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class PhraseEditorMediator extends RequestMediator {

	[Inject]
	public var view:PhraseForm;

	private var selectedPhrase:IPhrase = Phrase.NULL;
	private var isEditing:Boolean = false;

	override protected function onRegister():void {
		addHandler(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
		addHandler(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, phraseSelectedHandler);
	}

	private function toolActionSelectedHandler(toolAction:String):void {
		if (!isEditing && toolAction == ToolAction.EDIT && selectedPhrase != Phrase.NULL) {
			openForm();
			sendRequest(PhraseMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
		}
	}

	private function openForm():void {
		isEditing = true;
		view.edit(selectedPhrase.origin, selectedPhrase.translation);
		view.title = ToolActionName.getNameById(ToolAction.EDIT);
		sendMessage(PhraseMsg.FORM_ACTIVATED_NOTIFICATION);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function cancelHandler(event:MouseEvent):void {
		closeForm();
	}

	private function closeForm():void {
		isEditing = false;
		view.close();
		sendMessage(PhraseMsg.FORM_DEACTIVATED_NOTIFICATION);
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function onThemesLoaded(res:CommandResult):void {
		var themes:Array = res.data as Array;
		view.themes = new ArrayCollection(themes);
		sendRequest(PhraseMsg.GET_SELECTED_THEMES_ID, new RequestMessage(onSelectedThemesIDLoaded, null, selectedPhrase));
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

	private function phraseSelectedHandler(vo:Phrase):void {
		selectedPhrase = vo;
		if (isEditing) throw new Error("Should not select new phrase when the old one is editing!")
	}

	private function applyHandler(event:MouseEvent):void {
		sendUpdatePhraseRequest();
	}

	private function sendUpdatePhraseRequest():void {
		var suite:Object = {};
		suite.phrase = createPhrase();
		suite.themes = getSelectedThemes();
		sendRequest(PhraseMsg.UPDATE_PHRASE, new RequestMessage(updatePhraseCompleteHandler, updatePhraseErrorHandler, suite));
	}

	private function createPhrase():Phrase {
		var phrase:Phrase = new Phrase();
		phrase.id = selectedPhrase.id;
		phrase.origin = view.originArea.text;
		phrase.translation = view.translationArea.text;
		return phrase;
	}

	private function getSelectedThemes():Array {
		var res:Array = [];
		for each(var theme:ITheme in view.themesList.selectedItems) res.push(theme);
		return res;
	}

	private function updatePhraseCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	private function updatePhraseErrorHandler(exc:CommandException):void {
		view.notifyInvalidData(exc.details);
	}

	override protected function onRemove():void {
		removeAllHandlers();
		if (isEditing) {
			isEditing = false;
			closeForm();
		}
	}

}
}