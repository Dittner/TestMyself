package de.dittner.testmyself.backend.command {
import de.dittner.async.AsyncOperation;
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.testmyself.model.domain.test.TestModel;

public class GetTestInfoListCmd implements ISFCommand {

	[Inject]
	public var testModel:TestModel;

	public function execute(msg:IRequestMessage):void {
		var op:AsyncOperation = new AsyncOperation();
		op.dispatchSuccess(testModel.testInfos);
		msg.onComplete(op);
	}

}
}