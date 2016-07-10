package de.dittner.testmyself.ui.view.settings.noteSettings {
import de.dittner.async.IAsyncOperation;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.ModuleName;
import de.dittner.testmyself.model.domain.theme.ITheme;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class LessonSettingsMediator extends SFMediator {

	[Inject]
	public var view:NoteSettings;

	override protected function activate():void {
		view.editLbl.text = "Übungname ändern";
		view.removeLbl.text = "Übung mit den Aufgaben entfernen";
		view.themesList.title = "Übungenliste";
		view.notifyLbl.text = "Sind Sie sicher, die Übung mit den Aufgaben Sie entfernen möchten?";
		view.themeNameInputForm.title = "Geben Sie bitte den neuen Namen der Übung ein";

		sendRequestTo(ModuleName.LESSON, NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
		addListenerTo(ModuleName.LESSON, NoteMsg.THEMES_CHANGED_NOTIFICATION, themesChangedHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyBtnClickHandler);
	}

	protected function onThemesLoaded(op:IAsyncOperation):void {
		var themeItems:Array = op.result as Array;
		view.themes = new ArrayCollection(themeItems);
	}

	protected function themesChangedHandler(themeItems:Array):void {
		view.themes = new ArrayCollection(themeItems);
	}

	private function applyBtnClickHandler(event:MouseEvent):void {
		var selectedTheme:ITheme = view.themesList.selectedItem;
		if (!selectedTheme) return;

		if (view.isThemeRemoving) {
			sendRequestTo(ModuleName.LESSON, NoteMsg.REMOVE_NOTES_BY_THEME, new RequestMessage(null, selectedTheme))
		}
		else if (view.themeNameInputForm.text) {
			var theme:Theme = new Theme();
			theme.id = selectedTheme.id;
			theme.name = view.themeNameInputForm.text;

			var duplicate:ITheme = getThemeWithName(theme.name);
			if (duplicate) sendRequestTo(ModuleName.LESSON, NoteMsg.MERGE_THEMES, new RequestMessage(null, {
				destTheme: duplicate,
				srcTheme: selectedTheme
			}));
			else sendRequestTo(ModuleName.LESSON, NoteMsg.UPDATE_THEME, new RequestMessage(null, theme));
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