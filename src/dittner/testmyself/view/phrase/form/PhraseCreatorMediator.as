package dittner.testmyself.view.phrase.form {
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.theme.ITheme;
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class PhraseCreatorMediator extends RequestMediator {

	[Inject]
	public var view:PhraseForm;

	private var isCreating:Boolean = false;

	override protected function onRegister():void {
		addHandler(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
	}

	private function toolActionSelectedHandler(toolAction:String):void {
		if (!isCreating && toolAction == ToolAction.ADD) {
			openForm();
			sendRequest(PhraseMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
		}
	}

	private function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		view.themes = new ArrayCollection(themeItems);
	}

	private function openForm():void {
		isCreating = true;
		view.add();
		view.title = ToolActionName.getNameById(ToolAction.ADD);
		sendMessage(PhraseMsg.FORM_ACTIVATED_NOTIFICATION);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
		view.addThemeBtn.addEventListener(MouseEvent.CLICK, addThemeBtnClickHandler);
	}

	private function cancelHandler(event:MouseEvent):void {
		closeForm();
	}

	private function closeForm():void {
		isCreating = false;
		view.close();
		sendMessage(PhraseMsg.FORM_DEACTIVATED_NOTIFICATION);
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function applyHandler(event:MouseEvent):void {
		sendAddPhraseRequest();
	}

	private function sendAddPhraseRequest():void {
		var suite:Object = {};
		suite.phrase = createPhrase();
		suite.themes = getSelectedThemes();
		sendRequest(PhraseMsg.ADD_PHRASE, new RequestMessage(addPhraseCompleteHandler, addPhraseErrorHandler, suite));
	}

	private function createPhrase():Phrase {
		var phrase:Phrase = new Phrase();
		phrase.origin = view.originArea.text;
		phrase.translation = view.translationArea.text;
		return phrase;
	}

	private function getSelectedThemes():Array {
		var res:Array = [];
		for each(var theme:ITheme in view.themesList.selectedItems) res.push(theme);
		return res;
	}

	private function addPhraseCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	private function addPhraseErrorHandler(exc:CommandException):void {
		view.notifyInvalidData(exc.details);
	}

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

	override protected function onRemove():void {
		removeAllHandlers();
		if (isCreating) {
			isCreating = false;
			closeForm();
		}
	}

}
}