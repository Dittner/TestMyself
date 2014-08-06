package dittner.testmyself.command.phrase {
import dittner.testmyself.service.phrase.PhraseService;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Command;

public class GetThemesForPhraseCmd extends Command {

	[Inject]
	public var phraseService:PhraseService;

	public function execute(op:IRequestMessage):void {
		op.complete([]);
	}

}
}