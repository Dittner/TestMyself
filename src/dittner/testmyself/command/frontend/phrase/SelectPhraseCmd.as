package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.model.common.ITransUnitModel;
import dittner.testmyself.model.phrase.IPhrase;

import mvcexpress.mvc.Command;

public class SelectPhraseCmd extends Command {

	[Inject(name='phraseModel')]
	public var model:ITransUnitModel;

	public function execute(phrase:IPhrase):void {
		model.selectedTransUnit = phrase;
	}

}
}