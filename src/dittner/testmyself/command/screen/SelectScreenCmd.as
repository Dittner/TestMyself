package dittner.testmyself.command.screen {
import dittner.testmyself.model.MainModel;

import mvcexpress.mvc.Command;

public class SelectScreenCmd extends Command {

	[Inject]
	public var mainModel:MainModel;

	public function execute(screenId:uint):void {
		mainModel.selectedScreenId = screenId;
	}

}
}