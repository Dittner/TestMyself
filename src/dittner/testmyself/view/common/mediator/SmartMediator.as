package dittner.testmyself.view.common.mediator {
import mvcexpress.mvc.Mediator;

public class SmartMediator extends Mediator {
	public function SmartMediator() {
		super();
	}

	public function sendRequest(type:String, msg:IRequestMessage):void {
		sendMessage(type, msg);
	}
}
}
