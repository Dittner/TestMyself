package dittner.testmyself.command.tool {
import dittner.testmyself.message.ToolMsg;
import dittner.testmyself.model.phrase.PhraseModel;

import mvcexpress.mvc.Command;

public class GetToolsForPhraseCmd extends Command {

	[Inject]
	public var phraseModel:PhraseModel;

	public function execute(params:Object):void {
		sendMessage(ToolMsg.ON_TOOLS_FOR_PHRASE, phraseModel.getTools());
	}

}
}