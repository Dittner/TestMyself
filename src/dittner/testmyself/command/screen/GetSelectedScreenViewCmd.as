package dittner.testmyself.command.screen {
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;
import dittner.testmyself.service.helpers.screenFactory.ScreenInfo;

import mvcexpress.mvc.Command;

public class GetSelectedScreenViewCmd extends Command {

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(params:Object):void {
		if (params is ScreenInfo) {
			var screenId:uint = (params as ScreenInfo).id;
			sendMessage(ScreenMsg.ON_SELECTED_SCREEN_VIEW, screenFactory.generate(screenId));
		}
		else {
			sendMessage(ScreenMsg.ON_SELECTED_SCREEN_VIEW, screenFactory.generateFirstScreen());
		}
	}

}
}