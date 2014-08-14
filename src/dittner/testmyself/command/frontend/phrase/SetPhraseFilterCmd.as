package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.model.phrase.PhraseModel;

import mvcexpress.mvc.Command;

public class SetPhraseFilterCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	public function execute(filter:Vector.<Object>):void {
		model.filter = filter;
	}
}
}
