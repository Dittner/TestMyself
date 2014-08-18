package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.RequestMessage;

import mvcexpress.mvc.Command;

public class SetPhraseFilterCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	[Inject]
	public var service:PhraseService;

	public function execute(filter:Array):void {
		model.filter = filter;
		service.loadPageInfo(new RequestMessage(null, null, 0));
		service.loadDBInfo();
	}
}
}
