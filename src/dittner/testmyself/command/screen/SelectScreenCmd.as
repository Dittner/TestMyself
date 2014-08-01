package dittner.testmyself.command.screen {
import dittner.testmyself.model.MainModel;
import dittner.testmyself.service.helpers.screenFactory.ScreenInfo;

import mvcexpress.mvc.Command;

public class SelectScreenCmd extends Command {

	[Inject]
	public var mainModel:MainModel;

	public function execute(params:Object):void {
		mainModel.selectedScreenInfo = params as ScreenInfo;
	}

}
}