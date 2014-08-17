package dittner.testmyself.view.phrase.filter {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.theme.ITheme;
import dittner.testmyself.view.common.filter.ThemeFilter;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.toobar.ToolAction;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class PhraseFilterMediator extends RequestMediator {

	[Inject]
	public var view:ThemeFilter;

	private var isActive:Boolean = false;

	override protected function onRegister():void {
		addHandler(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
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
		sendMessage(PhraseMsg.FORM_ACTIVATED_NOTIFICATION);
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
		sendMessage(PhraseMsg.FORM_DEACTIVATED_NOTIFICATION);
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
		sendMessage(PhraseMsg.SET_FILTER, filter);
	}

	private function loadThemes():void {
		sendRequest(PhraseMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
	}

	private function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		view.themes = new ArrayCollection(themeItems);
		loadFilter();
	}

	private function loadFilter():void {
		sendRequest(PhraseMsg.GET_FILTER, new RequestMessage(onFilterLoaded));
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

}
}
