package dittner.testmyself.command.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.PhraseModel;

import mvcexpress.mvc.Command;

public class GetToolsForPhraseCmd extends Command {

	[Inject]
	public var phraseModel:PhraseModel;

	public function execute(params:Object):void {
		sendMessage(PhraseMsg.ON_TOOLS, phraseModel.getTools());
	}

}
}