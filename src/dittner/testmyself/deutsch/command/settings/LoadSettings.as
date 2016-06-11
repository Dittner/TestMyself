package dittner.testmyself.deutsch.command.settings {
import de.dittner.async.AsyncOperation;

import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.deutsch.model.settings.SettingsModel;

public class LoadSettings implements ISFCommand {

	[Inject]
	public var settingsModel:SettingsModel;

	public function execute(msg:IRequestMessage):void {
		var op:AsyncOperation = new AsyncOperation();
		op.dispatchSuccess(settingsModel.info);
		msg.onComplete(op);
	}
}
}
