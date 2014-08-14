package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.view.common.mediator.RequestMessage;

import mvcexpress.mvc.Command;

public class GetPhraseFilterCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	public function execute(requestMsg:RequestMessage):void {
		requestMsg.completeSuccess(new CommandResult(model.filter));
	}
}
}
