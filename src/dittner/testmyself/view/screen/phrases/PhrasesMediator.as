package dittner.testmyself.view.screen.phrases {
import dittner.testmyself.message.ToolMsg;

import mvcexpress.mvc.Mediator;

import mx.collections.ArrayCollection;

public class PhrasesMediator extends Mediator {

	[Inject]
	public var view:PhrasesView;

	override protected function onRegister():void {
		addHandler(ToolMsg.ON_PHRASES_TOOLS, showTools);
		sendMessage(ToolMsg.GET_PHRASES_TOOLS);
	}

	private function showTools(toolInfos:Array):void {
		view.toolProvider = new ArrayCollection(toolInfos);
	}

	override protected function onRemove():void {

	}
}
}