package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.model.screen.ScreenModel;

public class EditModeScreenCmd implements ISFCommand {

	[Inject]
	public var screenModel:ScreenModel;

	public function execute(msg:IRequestMessage):void {
		screenModel.editMode = msg.data;
	}

}
}