package dittner.testmyself.command.view {
import dittner.testmyself.message.ViewMsg;
import dittner.testmyself.view.core.IViewFactory;

import mvcexpress.mvc.Command;

public class GetAllViewInfosCmd extends Command {

	[Inject]
	public var viewFactory:IViewFactory;

	public function execute(params:Object):void {
		sendMessage(ViewMsg.ON_ALL_VIEW_INFOS, viewFactory.viewInfos);
	}

}
}