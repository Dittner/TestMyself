package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetPhraseDBInfoCmd extends Command {

	[Inject]
	public var service:PhraseService;

	public function execute(requestMsg:IRequestMessage):void {
		service.getDBInfo(requestMsg);
	}
}
}