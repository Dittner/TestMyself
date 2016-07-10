package de.dittner.testmyself.backend.command.screen {
import de.dittner.async.AsyncOperation;
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.testmyself.ui.service.screenFactory.IScreenFactory;

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