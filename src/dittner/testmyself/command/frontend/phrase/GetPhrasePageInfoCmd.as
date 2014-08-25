package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.model.common.ITransUnitModel;
import dittner.testmyself.service.TransUnitService;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetPhrasePageInfoCmd extends Command {

	[Inject(name='phraseService')]
	public var service:TransUnitService;

	[Inject(name='phraseModel')]
	public var model:ITransUnitModel;

	public function execute(requestMsg:IRequestMessage):void {
		var pageNum:uint = requestMsg.data as uint;
		if (model.pageInfo && model.pageInfo.pageNum == pageNum) {
			requestMsg.completeSuccess(new CommandResult(model.pageInfo));
		}
		else {
			service.loadPageInfo(requestMsg);
		}
	}
}
}
