package dittner.testmyself.command.screen {
import dittner.testmyself.model.MainModel;
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;
import dittner.testmyself.view.common.mediator.IOperationMessage;

import mvcexpress.mvc.Command;

public class GetSelectedScreenViewCmd extends Command {

	[Inject]
	public var mainModel:MainModel;

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(op:IOperationMessage):void {
		op.complete(screenFactory.generate(mainModel.selectedScreenId));
	}

}
}