package dittner.testmyself.deutsch.view.settings.phraseSettings {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.deutsch.message.SettingsMsg;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.settings.SettingsInfo;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class PhraseSettingsMediator extends SFMediator {

	[Inject]
	public var view:PhraseSettings;

	override protected function activate():void {
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded));
		sendRequestTo(ModuleName.PHRASE, NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
		addListenerTo(ModuleName.PHRASE, NoteMsg.THEMES_CHANGED_NOTIFICATION, themesChangedHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyBtnClickHandler);
	}

	protected function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		view.themes = new ArrayCollection(themeItems);
	}

	protected function themesChangedHandler(themeItems:Array):void {
		view.themes = new ArrayCollection(themeItems);
	}

	private function infoLoaded(res:CommandResult):void {
		var info:SettingsInfo = res.data as SettingsInfo;
		view.pageSizeSpinner.value = info.pageSize;
	}

	private function applyBtnClickHandler(event:MouseEvent):void {
		var selectedTheme:ITheme = view.themesList.selectedItem;
		if (!selectedTheme) return;

		if (view.isThemeRemoving) {
			sendRequestTo(ModuleName.PHRASE, NoteMsg.REMOVE_THEME, new RequestMessage(null, null, selectedTheme))
		}
		else if (view.themeNameInputForm.text) {
			var theme:Theme = new Theme();
			theme.id = selectedTheme.id;
			theme.name = view.themeNameInputForm.text;

			var duplicate:ITheme = getThemeWithName(theme.name);
			if (duplicate) sendRequestTo(ModuleName.PHRASE, NoteMsg.MERGE_THEMES, new RequestMessage(null, null, {destTheme: duplicate, srcTheme: selectedTheme}));
			else sendRequestTo(ModuleName.PHRASE, NoteMsg.UPDATE_THEME, new RequestMessage(null, null, theme));
		}
	}

	private function getThemeWithName(themeName:String):ITheme {
		for each(var theme:ITheme in view.themes) {
			if (theme.name == themeName) return theme;
		}
		return null;
	}

	override protected function deactivate():void {
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyBtnClickHandler);
	}
}
}