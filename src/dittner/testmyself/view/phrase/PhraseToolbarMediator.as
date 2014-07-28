package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.service.helpers.toolFactory.ToolId;
import dittner.testmyself.service.helpers.toolFactory.ToolInfo;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.common.toobar.Toolbar;

import flash.events.Event;

import mvcexpress.mvc.Mediator;

import mx.collections.ArrayCollection;

public class PhraseToolbarMediator extends Mediator {

	[Inject]
	public var view:Toolbar;

	private var toolHash:Object;
	override protected function onRegister():void {
		view.addEventListener(SelectableDataGroup.SELECTED, toolSelectedHandler);
		addHandler(PhraseMsg.ON_TOOLS, updateTools);
		sendMessage(PhraseMsg.GET_TOOLS);
	}

	private function toolSelectedHandler(event:Event):void {
		sendMessage(PhraseMsg.SELECT_TOOL, view.selectedItem);
	}

	private function updateTools(toolInfos:Array):void {
		toolHash = {};
		for each(var tool:ToolInfo in toolInfos) {
			toolHash[tool.id] = tool;
		}

		activateTool(ToolId.ADD);
		activateTool(ToolId.TRANS_INVERSION);
		activateTool(ToolId.FILTER);
		deactivateTool(ToolId.EDIT);
		deactivateTool(ToolId.DELETE);

		view.dataProvider = new ArrayCollection(toolInfos);
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
		view.removeEventListener(SelectableDataGroup.SELECTED, toolSelectedHandler);
		removeAllHandlers();
		view.dataProvider = null;
	}
}
}