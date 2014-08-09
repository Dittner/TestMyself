package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.model.phrase.IPhrase;
import dittner.testmyself.model.phrase.PhraseModel;

import mvcexpress.mvc.Command;

public class SelectPhraseCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	public function execute(phrase:IPhrase):void {
		model.selectedPhrase = phrase;
	}

}
}