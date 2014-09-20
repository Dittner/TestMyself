package dittner.testmyself.deutsch.command.test {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.deutsch.service.testFactory.ITestFactory;

public class GetTestInfoListCmd implements ISFCommand {

	[Inject]
	public var testFactory:ITestFactory;

	public function execute(msg:IRequestMessage):void {
		msg.completeSuccess(new CommandResult(testFactory.testInfos));
	}

}
}