package dittner.testmyself.command.frontend.settings {
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.model.settings.SettingsModel;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class LoadSettings extends Command {
	[Inject]
	public var model:SettingsModel;

	public function execute(requestMsg:IRequestMessage):void {
		requestMsg.completeSuccess(new CommandResult(model.info));
	}
}
}
