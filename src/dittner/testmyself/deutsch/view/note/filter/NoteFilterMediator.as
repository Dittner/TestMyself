package dittner.testmyself.deutsch.view.note.filter {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.deutsch.view.common.filter.ThemeFilter;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class NoteFilterMediator extends SFMediator {

	[Inject]
	public var view:ThemeFilter;

	private var isActive:Boolean = false;

	override protected function activate():void {
		addListener(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
	}

	private function toolActionSelectedHandler(toolAction:String):void {
		if (!isActive && toolAction == ToolAction.FILTER) {
			isActive = true;
			openDropdown();
			loadThemes();
		}
	}

	private function openDropdown():void {
		view.visible = true;
		sendNotification(NoteMsg.FORM_ACTIVATED_NOTIFICATION);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function cancelHandler(event:MouseEvent):void {
		closeDropdown();
	}

	private function closeDropdown():void {
		view.visible = false;
		isActive = false;
		view.close();
		sendNotification(NoteMsg.FORM_DEACTIVATED_NOTIFICATION);
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function applyHandler(event:MouseEvent):void {
		updateFilter();
		closeDropdown();
	}

	private function updateFilter():void {
		var filter:Array = [];
		for each(var item:* in view.themesList.selectedItems) filter.push(item);
		sendRequest(NoteMsg.SET_FILTER, new RequestMessage(null, null, filter));
	}

	private function loadThemes():void {
		sendRequest(NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
	}

	private function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		view.themes = new ArrayCollection(themeItems);
		loadFilter();
	}

	private function loadFilter():void {
		sendRequest(NoteMsg.GET_FILTER, new RequestMessage(onFilterLoaded));
	}

	private function onFilterLoaded(res:CommandResult):void {
		var filter:Array = res.data as Array;

		if (filter && filter.length > 0 && view.themes.length > 0) {
			var theme:ITheme;
			var isSelectedThemeHash:Object = {};
			var selectedItems:Vector.<Object> = new Vector.<Object>();
			for each(theme in filter) isSelectedThemeHash[theme.id] = true;
			for each(theme in view.themes)
				if (isSelectedThemeHash[theme.id]) selectedItems.push(theme);
			view.themesList.selectedItems = selectedItems;
		}
	}

	override protected function deactivate():void {}

}
}
