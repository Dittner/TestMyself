package dittner.testmyself.command.phrase {
import dittner.testmyself.service.PhraseService;

import mvcexpress.mvc.Command;

public class GetThemesForPhraseCmd extends Command {

	[Inject]
	public var phraseService:PhraseService;

	public function execute(params:Object):void {
		phraseService.loadThemes();
	}

}
}