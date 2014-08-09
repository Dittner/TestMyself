package dittner.testmyself.view.common.mediator {
import mvcexpress.mvc.Mediator;

public class RequestMediator extends Mediator {
	public function RequestMediator() {
		super();
	}

	public function sendRequest(type:String, msg:IRequestMessage):void {
		sendMessage(type, msg);
	}
}
}
