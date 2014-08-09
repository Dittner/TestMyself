package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.RequestMessage;

import mvcexpress.mvc.Command;

public class GetPhrasesCmd extends Command {

	[Inject]
	public var service:PhraseService;
	[Inject]
	public var model:PhraseModel;

	public function execute(requestMsg:RequestMessage):void {
		if(model.phrases) requestMsg.completeSuccess(model.phrases);
		else service.getPhrases(requestMsg);
	}
}
}
