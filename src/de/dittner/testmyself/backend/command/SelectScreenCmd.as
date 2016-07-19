package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.model.screen.ScreenModel;

public class SelectScreenCmd implements ISFCommand {

	[Inject]
	public var screenModel:ScreenModel;

	public function execute(msg:IRequestMessage):void {
		screenModel.selectedScreenID = msg.data as String;
	}

}
}