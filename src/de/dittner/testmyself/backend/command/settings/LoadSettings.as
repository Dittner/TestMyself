package de.dittner.testmyself.backend.command.settings {
import de.dittner.async.AsyncOperation;
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.testmyself.model.settings.SettingsModel;

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
