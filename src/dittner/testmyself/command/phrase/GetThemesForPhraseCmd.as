package dittner.testmyself.command.phrase {
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.IOperationMessage;

import mvcexpress.mvc.Command;

public class GetThemesForPhraseCmd extends Command {

	[Inject]
	public var phraseService:PhraseService;

	public function execute(op:IOperationMessage):void {
		phraseService.loadThemes(op);
	}

}
}