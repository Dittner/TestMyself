package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.service.helpers.toolFactory.ToolId;
import dittner.testmyself.service.helpers.toolFactory.Tool;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.common.mediator.RequestOperationMessage;
import dittner.testmyself.view.common.mediator.SmartMediator;
import dittner.testmyself.view.common.toobar.Toolbar;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class PhraseToolbarMediator extends SmartMediator {

	[Inject]
	public var view:Toolbar;

	private var toolHash:Object;
	override protected function onRegister():void {
		view.addEventListener(SelectableDataGroup.SELECTED, toolSelectedHandler);
		requestData(PhraseMsg.GET_TOOLS, new RequestOperationMessage(onToolsLoaded));
	}

	private function toolSelectedHandler(event:Event):void {
		sendMessage(PhraseMsg.SELECT_TOOL, view.selectedItem ? view.selectedItem : Tool.NULL);
	}

	private function onToolsLoaded(tools:Array):void {
		toolHash = {};
		for each(var tool:Tool in tools) {
			toolHash[tool.id] = tool;
		}

		activateTool(ToolId.ADD);
		activateTool(ToolId.TRANS_INVERSION);
		activateTool(ToolId.FILTER);
		deactivateTool(ToolId.EDIT);
		deactivateTool(ToolId.REMOVE);

		view.dataProvider = new ArrayCollection(tools);
	}

	private function activateTool(toolId:uint):void {
		var tool:Tool = toolHash[toolId];
		if (tool) tool.active = true;
	}

	private function deactivateTool(toolId:uint):void {
		var tool:Tool = toolHash[toolId];
		if (tool) tool.active = false;
	}

	override protected function onRemove():void {
		view.removeEventListener(SelectableDataGroup.SELECTED, toolSelectedHandler);
		removeAllHandlers();
		view.dataProvider = null;
	}
}
}