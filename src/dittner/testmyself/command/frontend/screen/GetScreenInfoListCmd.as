package dittner.testmyself.command.frontend.screen {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.service.screenFactory.IScreenFactory;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetScreenInfoListCmd extends Command {

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(op:IRequestMessage):void {
		op.completeSuccess(new CommandResult(screenFactory.screenInfos));
	}

}
}