package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.service.TransUnitService;
import dittner.testmyself.view.common.mediator.RequestMessage;

import mvcexpress.mvc.Command;

public class MergePhraseThemesCmd extends Command {

	[Inject(name='phraseService')]
	public var service:TransUnitService;

	public function execute(requestMsg:RequestMessage):void {
		service.mergeThemes(requestMsg);
	}
}
}
