package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetPhraseDBInfoCmd extends Command {

	[Inject]
	public var service:PhraseService;

	[Inject]
	public var model:PhraseModel;

	public function execute(requestMsg:IRequestMessage):void {
		if (model.dataBaseInfo) requestMsg.completeSuccess(new CommandResult(model.dataBaseInfo));
		else service.loadDBInfo(requestMsg);
	}
}
}