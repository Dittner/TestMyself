package dittner.testmyself.deutsch.view.settings.noteSettings {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.deutsch.model.ModuleName;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class LessonSettingsMediator extends SFMediator {

	[Inject]
	public var view:NoteSettings;

	override protected function activate():void {
		view.editLbl.text = "Lektionname ändern";
		view.removeLbl.text = "Lektion mit den Aufgaben entfernen";
		view.themesList.title = "Lektionenliste";
		view.notifyLbl.text = "Sind Sie sicher, die Lektion mit den Aufgaben Sie entfernen möchten?";
		view.themeNameInputForm.title = "Geben Sie bitte den neuen Namen der Lektion ein";

		sendRequestTo(ModuleName.LESSON, NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
		addListenerTo(ModuleName.LESSON, NoteMsg.THEMES_CHANGED_NOTIFICATION, themesChangedHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyBtnClickHandler);
	}

	protected function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		view.themes = new ArrayCollection(themeItems);
	}

	protected function themesChangedHandler(themeItems:Array):void {
		view.themes = new ArrayCollection(themeItems);
	}

	private function applyBtnClickHandler(event:MouseEvent):void {
		var selectedTheme:ITheme = view.themesList.selectedItem;
		if (!selectedTheme) return;

		if (view.isThemeRemoving) {
			sendRequestTo(ModuleName.LESSON, NoteMsg.REMOVE_NOTES_BY_THEME, new RequestMessage(null, null, selectedTheme))
		}
		else if (view.themeNameInputForm.text) {
			var theme:Theme = new Theme();
			theme.id = selectedTheme.id;
			theme.name = view.themeNameInputForm.text;

			var duplicate:ITheme = getThemeWithName(theme.name);
			if (duplicate) sendRequestTo(ModuleName.LESSON, NoteMsg.MERGE_THEMES, new RequestMessage(null, null, {destTheme: duplicate, srcTheme: selectedTheme}));
			else sendRequestTo(ModuleName.LESSON, NoteMsg.UPDATE_THEME, new RequestMessage(null, null, theme));
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