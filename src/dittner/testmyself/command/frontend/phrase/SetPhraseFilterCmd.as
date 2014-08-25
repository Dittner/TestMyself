package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.model.common.ITransUnitModel;
import dittner.testmyself.service.TransUnitService;
import dittner.testmyself.view.common.mediator.RequestMessage;

import mvcexpress.mvc.Command;

public class SetPhraseFilterCmd extends Command {

	[Inject(name='phraseService')]
	public var service:TransUnitService;

	[Inject(name='phraseModel')]
	public var model:ITransUnitModel;

	public function execute(filter:Array):void {
		model.filter = filter;
		service.loadPageInfo(new RequestMessage(null, null, 0));
		service.loadDBInfo();
	}
}
}
