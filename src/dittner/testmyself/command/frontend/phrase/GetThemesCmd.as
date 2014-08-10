package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetThemesCmd extends Command {

	[Inject]
	public var service:PhraseService;

	[Inject]
	public var model:PhraseModel;

	public function execute(msg:IRequestMessage):void {
		if (model.themes) msg.completeSuccess(new CommandResult(model.themes));
		else service.getThemes(msg);
	}

}
}