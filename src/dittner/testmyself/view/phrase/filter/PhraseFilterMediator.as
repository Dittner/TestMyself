package dittner.testmyself.view.phrase.filter {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
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
		sendMessage(PhraseMsg.SET_FILTER, view.themesList.selectedItems);
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
		view.themesList.selectedItems = res.data as Vector.<Object>;
	}

}
}
