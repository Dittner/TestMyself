package de.dittner.testmyself.backend.command {
import de.dittner.async.AsyncOperation;
import de.dittner.testmyself.model.screen.ScreenModel;

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