package dittner.testmyself.command.app {
import dittner.testmyself.command.frontend.phrase.AddPhraseCmd;
import dittner.testmyself.command.frontend.phrase.GetPhraseDBInfoCmd;
import dittner.testmyself.command.frontend.phrase.GetPhraseFilterCmd;
import dittner.testmyself.command.frontend.phrase.GetPhrasePageInfoCmd;
import dittner.testmyself.command.frontend.phrase.GetSelectedPhraseCmd;
import dittner.testmyself.command.frontend.phrase.GetSelectedPhraseThemesIDCmd;
import dittner.testmyself.command.frontend.phrase.GetThemesCmd;
import dittner.testmyself.command.frontend.phrase.RemovePhraseCmd;
import dittner.testmyself.command.frontend.phrase.SelectPhraseCmd;
import dittner.testmyself.command.frontend.phrase.SetPhraseFilterCmd;
import dittner.testmyself.command.frontend.phrase.UpdatePhraseCmd;
import dittner.testmyself.message.PhraseMsg;

import mvcexpress.mvc.Command;

public class SetupPhraseCommands extends Command {
	public function execute(params:Object):void {
		commandMap.map(PhraseMsg.SELECT_PHRASE, SelectPhraseCmd);
		commandMap.map(PhraseMsg.GET_SELECTED_PHRASE, GetSelectedPhraseCmd);
		commandMap.map(PhraseMsg.GET_FILTER, GetPhraseFilterCmd);
		commandMap.map(PhraseMsg.SET_FILTER, SetPhraseFilterCmd);

		/*sql*/
		commandMap.map(PhraseMsg.ADD_PHRASE, AddPhraseCmd);
		commandMap.map(PhraseMsg.REMOVE_PHRASE, RemovePhraseCmd);
		commandMap.map(PhraseMsg.UPDATE_PHRASE, UpdatePhraseCmd);
		commandMap.map(PhraseMsg.GET_PAGE_INFO, GetPhrasePageInfoCmd);
		commandMap.map(PhraseMsg.GET_THEMES, GetThemesCmd);
		commandMap.map(PhraseMsg.GET_SELECTED_THEMES_ID, GetSelectedPhraseThemesIDCmd);
		commandMap.map(PhraseMsg.GET_DATA_BASE_INFO, GetPhraseDBInfoCmd);
	}

}
}
