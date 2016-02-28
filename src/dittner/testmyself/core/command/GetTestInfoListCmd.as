package dittner.testmyself.core.command {
import dittner.async.AsyncOperation;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.test.TestModel;

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