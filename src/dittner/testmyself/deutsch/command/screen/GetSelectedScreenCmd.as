package dittner.testmyself.deutsch.command.screen {
import dittner.async.AsyncOperation;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.deutsch.model.screen.ScreenModel;

public class GetSelectedScreenCmd implements ISFCommand {

	[Inject]
	public var screenModel:ScreenModel;

	public function execute(msg:IRequestMessage):void {
		var op:AsyncOperation = new AsyncOperation();
		op.dispatchSuccess(screenModel.selectedScreen);
		msg.onComplete(op);
	}

}
}