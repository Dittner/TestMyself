package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetSelectedPhraseThemesIDCmd extends Command {

	[Inject]
	public var service:PhraseService;

	public function execute(msg:IRequestMessage):void {
		service.getSelectedThemesID(msg);
	}

}
}