package dittner.testmyself.command.phrase {
import dittner.testmyself.model.phrase.PhraseModel;

import mvcexpress.mvc.Command;

public class ClearPhraseModelCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	public function execute(params:Object):void {
		model.clear();
	}

}
}