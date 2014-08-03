package dittner.testmyself.command.phrase {
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.model.phrase.PhraseVo;

import mvcexpress.mvc.Command;

public class SelectPhraseCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	public function execute(phrase:PhraseVo):void {
		model.selectedPhrase = phrase;
	}

}
}