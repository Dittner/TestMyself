package dittner.testmyself.command.phrase {
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.view.common.mediator.IOperationMessage;

import mvcexpress.mvc.Command;

public class GetToolsForPhraseCmd extends Command {

	[Inject]
	public var phraseModel:PhraseModel;

	public function execute(op:IOperationMessage):void {
		op.complete(phraseModel.getTools());
	}

}
}