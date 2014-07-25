package dittner.testmyself.command.service {
import dittner.testmyself.service.DataBaseInfoService;

import mvcexpress.mvc.Command;

public class GetDataBaseInfoCmd extends Command {

	[Inject]
	public var service:DataBaseInfoService;

	public function execute(params:Object):void {
		service.load();
	}

}
}