package dittner.testmyself.core.command {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.model.test.TestSpec;

public class SelectTestSpecCmd implements ISFCommand {

	[Inject]
	public var testModel:TestModel;

	public function execute(msg:IRequestMessage):void {
		testModel.testSpec = msg.data as TestSpec;
	}

}
}