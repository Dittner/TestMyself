package dittner.testmyself.view.screen.phrase {
import dittner.testmyself.message.ToolMsg;
import dittner.testmyself.service.helpers.toolFactory.ToolId;
import dittner.testmyself.service.helpers.toolFactory.ToolInfo;
import dittner.testmyself.view.common.SelectableDataGroup;

import flash.events.Event;

import mvcexpress.mvc.Mediator;

import mx.collections.ArrayCollection;

public class PhraseMediator extends Mediator {

	[Inject]
	public var view:PhraseView;

	private var toolHash:Object;
	override protected function onRegister():void {
		view.toolbar.addEventListener(SelectableDataGroup.SELECTED, toolSelectedHandler);
		addHandler(ToolMsg.ON_TOOLS_FOR_PHRASE, parseTools);
		sendMessage(ToolMsg.GET_TOOLS_FOR_PHRASE);
	}

	private function parseTools(toolInfos:Array):void {
		toolHash = {};
		for each(var tool:ToolInfo in toolInfos) {
			toolHash[tool.id] = tool;
		}

		activateTool(ToolId.ADD);
		activateTool(ToolId.TRANS_INVERSION);
		activateTool(ToolId.FILTER);
		deactivateTool(ToolId.EDIT);
		deactivateTool(ToolId.DELETE);

		view.toolProvider = new ArrayCollection(toolInfos);
	}

	private function activateTool(toolId:uint):void {
		var tool:ToolInfo = toolHash[toolId];
		if (tool) tool.active = true;
	}

	private function deactivateTool(toolId:uint):void {
		var tool:ToolInfo = toolHash[toolId];
		if (tool) tool.active = false;
	}

	override protected function onRemove():void {
		view.toolbar.removeEventListener(SelectableDataGroup.SELECTED, toolSelectedHandler);
		removeAllHandlers();
		toolHash = null;
	}

	private function toolSelectedHandler(event:Event):void {
		view.activateEditMode();
	}
}
}