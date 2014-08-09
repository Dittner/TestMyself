package dittner.testmyself.command.frontend.screen {
import dittner.testmyself.service.screenFactory.IScreenFactory;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GenerateScreenCmd extends Command {

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(op:IRequestMessage):void {
		var screenID:uint = op.data as uint;
		op.completeSuccess(screenFactory.generate(screenID));
	}

}
}