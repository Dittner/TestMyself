package dittner.testmyself.command.view {
import dittner.testmyself.message.ViewMsg;
import dittner.testmyself.view.core.IViewFactory;
import dittner.testmyself.view.core.ViewInfo;

import mvcexpress.mvc.Command;

public class GetSelectedViewCmd extends Command {

	[Inject]
	public var viewFactory:IViewFactory;

	public function execute(params:Object):void {
		if (params is ViewInfo) {
			var viewId:uint = (params as ViewInfo).id;
			sendMessage(ViewMsg.ON_SELECTED_VIEW, viewFactory.generate(viewId));
		}
		else {
			sendMessage(ViewMsg.ON_SELECTED_VIEW, viewFactory.generateFirstView());
		}
	}

}
}