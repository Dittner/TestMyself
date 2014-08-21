package dittner.testmyself.view.settings.phraseSettings {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.message.SettingsMsg;
import dittner.testmyself.model.common.SettingsInfo;
import dittner.testmyself.model.theme.ITheme;
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class PhraseSettingsMediator extends RequestMediator {

	[Inject]
	public var form:PhraseSettings;

	override protected function onRegister():void {
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded));
		sendRequest(PhraseMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
		addHandler(PhraseMsg.THEMES_CHANGED_NOTIFICATION, themesChangedHandler);
		form.applyBtn.addEventListener(MouseEvent.CLICK, applyBtnClickHandler);
	}

	protected function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		form.themes = new ArrayCollection(themeItems);
	}

	protected function themesChangedHandler(themeItems:Array):void {
		form.themes = new ArrayCollection(themeItems);
	}

	private function infoLoaded(res:CommandResult):void {
		var info:SettingsInfo = res.data as SettingsInfo;
		form.pageSizeSpinner.value = info.phrasePageSize;
	}

	private function applyBtnClickHandler(event:MouseEvent):void {
		var selectedTheme:ITheme = form.themesList.selectedItem;
		if (!selectedTheme) return;

		if (form.isThemeRemoving) {
			sendRequest(PhraseMsg.REMOVE_THEME, new RequestMessage(null, null, selectedTheme))
		}
		else if (form.themeNameInputForm.text) {
			var theme:Theme = new Theme();
			theme.id = selectedTheme.id;
			theme.name = form.themeNameInputForm.text;

			var duplicate:ITheme = getThemeWithName(theme.name);
			if (duplicate) sendRequest(PhraseMsg.MERGE_THEMES, new RequestMessage(null, null, {destTheme: duplicate, srcTheme: selectedTheme}));
			else sendRequest(PhraseMsg.UPDATE_THEME, new RequestMessage(null, null, theme));
		}
	}

	private function getThemeWithName(themeName:String):ITheme {
		for each(var theme:ITheme in form.themes) {
			if (theme.name == themeName) return theme;
		}
		return null;
	}

	override protected function onRemove():void {
		form.applyBtn.removeEventListener(MouseEvent.CLICK, applyBtnClickHandler);
		removeAllHandlers();
	}
}
}