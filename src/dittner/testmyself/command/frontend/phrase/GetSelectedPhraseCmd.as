package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.model.common.ITransUnitModel;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetSelectedPhraseCmd extends Command {

	[Inject(name='phraseModel')]
	public var model:ITransUnitModel;

	public function execute(op:IRequestMessage):void {
		op.completeSuccess(new CommandResult(model.selectedTransUnit));
	}

}
}