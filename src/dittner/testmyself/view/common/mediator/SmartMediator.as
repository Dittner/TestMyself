package dittner.testmyself.view.common.mediator {
import mvcexpress.mvc.Mediator;

public class SmartMediator extends Mediator {
	public function SmartMediator() {
		super();
	}

	public function requestData(type:String, loadMsg:IOperationMessage):void {
		sendMessage(type, loadMsg);
	}
}
}
