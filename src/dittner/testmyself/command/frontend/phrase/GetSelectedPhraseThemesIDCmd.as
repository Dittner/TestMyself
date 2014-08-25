package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.service.TransUnitService;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetSelectedPhraseThemesIDCmd extends Command {

	[Inject(name='phraseService')]
	public var service:TransUnitService;

	public function execute(msg:IRequestMessage):void {
		service.getSelectedThemesID(msg);
	}

}
}