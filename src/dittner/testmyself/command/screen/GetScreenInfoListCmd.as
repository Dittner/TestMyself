package dittner.testmyself.command.screen {
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;

import mvcexpress.mvc.Command;

public class GetScreenInfoListCmd extends Command {

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(params:Object):void {
		sendMessage(ScreenMsg.ON_SCREEN_INFO_LIST, screenFactory.screens);
	}

}
}