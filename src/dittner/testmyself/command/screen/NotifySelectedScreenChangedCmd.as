package dittner.testmyself.command.screen {
import dittner.testmyself.model.MainModel;
import dittner.testmyself.service.helpers.screenFactory.ScreenInfo;

import mvcexpress.mvc.Command;

public class NotifySelectedScreenChangedCmd extends Command {

	[Inject]
	public var mainModel:MainModel;

	public function execute(params:Object):void {
		mainModel.activeScreenInfo = params as ScreenInfo;
	}

}
}