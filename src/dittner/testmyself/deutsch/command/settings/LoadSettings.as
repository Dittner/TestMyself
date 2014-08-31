package dittner.testmyself.deutsch.command.settings {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.deutsch.model.settings.SettingsModel;

public class LoadSettings implements ISFCommand {

	[Inject]
	public var settingsModel:SettingsModel;

	public function execute(msg:IRequestMessage):void {
		msg.completeSuccess(new CommandResult(settingsModel.info));
	}
}
}
