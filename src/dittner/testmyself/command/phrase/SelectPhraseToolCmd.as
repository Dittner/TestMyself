package dittner.testmyself.command.phrase {
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.helpers.toolFactory.Tool;

import mvcexpress.mvc.Command;

public class SelectPhraseToolCmd extends Command {

	[Inject]
	public var model:PhraseModel;

	public function execute(tool:Tool):void {
		model.selectedTool = tool;
	}

}
}