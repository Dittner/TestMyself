package dittner.testmyself.command.screen {
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;
import dittner.testmyself.view.common.mediator.IOperationMessage;

import mvcexpress.mvc.Command;

public class GetScreenInfoListCmd extends Command {

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(op:IOperationMessage):void {
		op.complete(screenFactory.screenInfos);
	}

}
}