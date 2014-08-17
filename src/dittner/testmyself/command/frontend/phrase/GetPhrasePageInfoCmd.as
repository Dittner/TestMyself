package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetPhrasePageInfoCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	[Inject]
	public var service:PhraseService;

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
