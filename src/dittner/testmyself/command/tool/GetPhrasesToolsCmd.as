package dittner.testmyself.command.tool {
import dittner.testmyself.message.ToolMsg;
import dittner.testmyself.service.helpers.toolFactory.IToolFactory;
import dittner.testmyself.service.helpers.toolFactory.ToolId;

import mvcexpress.mvc.Command;

public class GetPhrasesToolsCmd extends Command {

	[Inject]
	public var toolFactory:IToolFactory;

	public function execute(params:Object):void {
		var toolIds:Array = [
			ToolId.ADD,
			ToolId.EDIT,
			ToolId.DELETE,
			ToolId.TRANS_INVERSION,
			ToolId.FILTER
		];

		var toolInfos:Array = toolFactory.generateInfos(toolIds);
		sendMessage(ToolMsg.ON_PHRASES_TOOLS, toolInfos);
	}

}
}