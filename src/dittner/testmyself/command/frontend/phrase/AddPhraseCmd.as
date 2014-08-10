package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.RequestMessage;

import mvcexpress.mvc.Command;

public class AddPhraseCmd extends Command {

	[Inject]
	public var service:PhraseService;

	public function execute(requestMsg:RequestMessage):void {
		service.addPhrase(requestMsg);
	}
}
}