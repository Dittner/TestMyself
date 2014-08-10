package dittner.testmyself.command.app {
import dittner.testmyself.command.frontend.phrase.AddPhraseCmd;
import dittner.testmyself.command.frontend.phrase.GetPhrasesCmd;
import dittner.testmyself.command.frontend.phrase.GetSelectedPhraseCmd;
import dittner.testmyself.command.frontend.phrase.GetSelectedPhraseThemesIDCmd;
import dittner.testmyself.command.frontend.phrase.GetThemesCmd;
import dittner.testmyself.command.frontend.phrase.RemovePhraseCmd;
import dittner.testmyself.command.frontend.phrase.SelectPhraseCmd;
import dittner.testmyself.command.frontend.phrase.UpdatePhraseCmd;
import dittner.testmyself.message.PhraseMsg;

import mvcexpress.mvc.Command;

public class SetupPhraseCommands extends Command {
	public function execute(params:Object):void {
		commandMap.map(PhraseMsg.SELECT_PHRASE, SelectPhraseCmd);
		commandMap.map(PhraseMsg.GET_SELECTED_PHRASE, GetSelectedPhraseCmd);

		commandMap.map(PhraseMsg.ADD_PHRASE, AddPhraseCmd);
		commandMap.map(PhraseMsg.REMOVE_PHRASE, RemovePhraseCmd);
		commandMap.map(PhraseMsg.UPDATE_PHRASE, UpdatePhraseCmd);
		commandMap.map(PhraseMsg.GET_PHRASES, GetPhrasesCmd);
		commandMap.map(PhraseMsg.GET_THEMES, GetThemesCmd);
		commandMap.map(PhraseMsg.GET_SELECTED_THEMES_ID, GetSelectedPhraseThemesIDCmd);
	}

}
}
