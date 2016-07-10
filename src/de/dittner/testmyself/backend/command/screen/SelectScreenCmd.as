package de.dittner.testmyself.backend.command.screen {
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.testmyself.model.screen.ScreenModel;

public class SelectScreenCmd implements ISFCommand {

	[Inject]
	public var screenModel:ScreenModel;

	public function execute(msg:IRequestMessage):void {
		screenModel.selectedScreenID = msg.data as String;
	}

}
}