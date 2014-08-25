package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.model.common.ITransUnitModel;
import dittner.testmyself.view.common.mediator.RequestMessage;

import mvcexpress.mvc.Command;

public class GetPhraseFilterCmd extends Command {

	[Inject(name='phraseModel')]
	public var model:ITransUnitModel;

	public function execute(requestMsg:RequestMessage):void {
		requestMsg.completeSuccess(new CommandResult(model.filter));
	}
}
}
