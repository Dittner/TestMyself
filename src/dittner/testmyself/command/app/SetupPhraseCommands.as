package dittner.testmyself.command.app {
import dittner.testmyself.command.phrase.ClearPhraseModelCmd;
import dittner.testmyself.command.phrase.CreatePhraseDBCmd;
import dittner.testmyself.command.sql.phrase.GetPhrasesCmd;
import dittner.testmyself.command.phrase.GetSelectedPhraseCmd;
import dittner.testmyself.command.phrase.GetThemesForPhraseCmd;
import dittner.testmyself.command.phrase.SelectPhraseCmd;
import dittner.testmyself.command.sql.phrase.AddPhraseCmd;
import dittner.testmyself.message.PhraseMsg;

import mvcexpress.mvc.Command;

public class SetupPhraseCommands extends Command {
	public function execute(params:Object):void {
		commandMap.map(PhraseMsg.SELECT_PHRASE, SelectPhraseCmd);
		commandMap.map(PhraseMsg.CLEAR_MODEL, ClearPhraseModelCmd);
		commandMap.map(PhraseMsg.GET_THEMES, GetThemesForPhraseCmd);
		commandMap.map(PhraseMsg.GET_PHRASES, GetPhrasesCmd);
		commandMap.map(PhraseMsg.GET_SELECTED_PHRASE, GetSelectedPhraseCmd);

		/*sql*/
		commandMap.map(PhraseMsg.CREATE_DB, CreatePhraseDBCmd);
		commandMap.map(PhraseMsg.ADD_PHRASE, AddPhraseCmd);
	}

}
}
