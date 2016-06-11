package dittner.testmyself.deutsch.command.screen {
import de.dittner.async.AsyncOperation;

import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.deutsch.service.screenFactory.IScreenFactory;

public class GetScreenInfoListCmd implements ISFCommand {

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(msg:IRequestMessage):void {
		var op:AsyncOperation = new AsyncOperation();
		op.dispatchSuccess(screenFactory.screenInfos);
		msg.onComplete(op);
	}

}
}