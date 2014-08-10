package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetSelectedPhraseCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	public function execute(op:IRequestMessage):void {
		op.completeSuccess(new CommandResult(model.selectedPhrase));
	}

}
}