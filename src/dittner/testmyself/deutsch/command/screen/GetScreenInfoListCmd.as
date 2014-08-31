package dittner.testmyself.deutsch.command.screen {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.deutsch.service.screenFactory.IScreenFactory;

public class GetScreenInfoListCmd implements ISFCommand {

	[Inject]
	public var screenFactory:IScreenFactory;

	public function execute(msg:IRequestMessage):void {
		msg.completeSuccess(new CommandResult(screenFactory.screenInfos));
	}

}
}