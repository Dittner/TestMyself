package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.model.common.ITransUnitModel;
import dittner.testmyself.service.TransUnitService;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetPhraseDBInfoCmd extends Command {

	[Inject(name='phraseService')]
	public var service:TransUnitService;

	[Inject(name='phraseModel')]
	public var model:ITransUnitModel;

	public function execute(requestMsg:IRequestMessage):void {
		if (model.dataBaseInfo) requestMsg.completeSuccess(new CommandResult(model.dataBaseInfo));
		else service.loadDBInfo(requestMsg);
	}
}
}