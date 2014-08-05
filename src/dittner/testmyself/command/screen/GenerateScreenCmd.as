package dittner.testmyself.command.screen {
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;
import dittner.testmyself.view.common.mediator.IOperationMessage;

import mvcexpress.mvc.Command;

public class GenerateScreenCmd extends Command {

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(op:IOperationMessage):void {
		var screenID:uint = op.data as uint;
		op.complete(screenFactory.generate(screenID));
	}

}
}