package dittner.testmyself.command.frontend.phrase {
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.PhraseService;

import mvcexpress.mvc.Command;

public class SetPhraseFilterCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	[Inject]
	public var service:PhraseService;

	public function execute(filter:Vector.<Object>):void {
		model.filter = filter;
		service.reloadData();
	}
}
}
