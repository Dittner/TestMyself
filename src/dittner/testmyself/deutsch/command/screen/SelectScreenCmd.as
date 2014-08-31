package dittner.testmyself.deutsch.command.screen {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.deutsch.model.screen.ScreenModel;

public class SelectScreenCmd implements ISFCommand {

	[Inject]
	public var screenModel:ScreenModel;

	public function execute(msg:IRequestMessage):void {
		screenModel.selectedScreenID = msg.data as String;
	}

}
}