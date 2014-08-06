package dittner.testmyself.command.screen {
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetScreenInfoListCmd extends Command {

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(op:IRequestMessage):void {
		op.complete(screenFactory.screenInfos);
	}

}
}