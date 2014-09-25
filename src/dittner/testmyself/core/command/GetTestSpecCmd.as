package dittner.testmyself.core.command {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.core.model.test.TestModel;

public class GetTestSpecCmd implements ISFCommand {

	[Inject]
	public var testModel:TestModel;

	public function execute(msg:IRequestMessage):void {
		msg.completeSuccess(new CommandResult(testModel.testSpec));
	}

}
}