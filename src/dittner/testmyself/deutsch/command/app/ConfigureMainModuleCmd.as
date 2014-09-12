package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.RootModule;
import dittner.satelliteFlight.module.SFModule;
import dittner.testmyself.core.command.AddNoteCmd;
import dittner.testmyself.core.command.ClearNotesInfoCmd;
import dittner.testmyself.core.command.GetNoteExamplesCmd;
import dittner.testmyself.core.command.GetNoteFilterCmd;
import dittner.testmyself.core.command.GetNoteHashCmd;
import dittner.testmyself.core.command.GetNoteThemesCmd;
import dittner.testmyself.core.command.GetNotesInfoCmd;
import dittner.testmyself.core.command.GetPageInfoCmd;
import dittner.testmyself.core.command.GetSelectedNoteCmd;
import dittner.testmyself.core.command.GetSelectedNoteThemesIDCmd;
import dittner.testmyself.core.command.MergeNoteThemesCmd;
import dittner.testmyself.core.command.RemoveNoteCmd;
import dittner.testmyself.core.command.RemoveNoteThemeCmd;
import dittner.testmyself.core.command.SelectNoteCmd;
import dittner.testmyself.core.command.SetNoteFilterCmd;
import dittner.testmyself.core.command.UpdateNoteCmd;
import dittner.testmyself.core.command.UpdateNoteThemeCmd;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperationManager;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.command.screen.GetScreenInfoListCmd;
import dittner.testmyself.deutsch.command.screen.GetSelectedScreenCmd;
import dittner.testmyself.deutsch.command.screen.LockScreenCmd;
import dittner.testmyself.deutsch.command.screen.SelectScreenCmd;
import dittner.testmyself.deutsch.command.screen.UnlockScreenCmd;
import dittner.testmyself.deutsch.command.settings.LoadSettings;
import dittner.testmyself.deutsch.command.settings.StoreSettings;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.message.SettingsMsg;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.screen.ScreenModel;
import dittner.testmyself.deutsch.model.settings.SettingsModel;
import dittner.testmyself.deutsch.service.screenFactory.ScreenFactory;
import dittner.testmyself.deutsch.service.screenMediatorFactory.ScreenMediatorFactory;
import dittner.testmyself.deutsch.view.common.tooltip.CustomToolTipManager;

public class ConfigureMainModuleCmd implements IConfigureCommand {

	public function execute(mainModule:SFModule):void {
		//register commands
		mainModule.registerCmd(ScreenMsg.SELECT_SCREEN, SelectScreenCmd);
		mainModule.registerCmd(ScreenMsg.GET_SELECTED_SCREEN, GetSelectedScreenCmd);
		mainModule.registerCmd(ScreenMsg.GET_SCREEN_INFO_LIST, GetScreenInfoListCmd);
		mainModule.registerCmd(ScreenMsg.LOCK, LockScreenCmd);
		mainModule.registerCmd(ScreenMsg.UNLOCK, UnlockScreenCmd);
		mainModule.registerCmd(SettingsMsg.LOAD, LoadSettings);
		mainModule.registerCmd(SettingsMsg.STORE, StoreSettings);

		//common note commands
		mainModule.registerCmd(NoteMsg.SELECT_NOTE, SelectNoteCmd);
		mainModule.registerCmd(NoteMsg.GET_SELECTED_NOTE, GetSelectedNoteCmd);
		mainModule.registerCmd(NoteMsg.GET_FILTER, GetNoteFilterCmd);
		mainModule.registerCmd(NoteMsg.SET_FILTER, SetNoteFilterCmd);

		/*sql*/
		mainModule.registerCmd(NoteMsg.ADD_NOTE, AddNoteCmd);
		mainModule.registerCmd(NoteMsg.REMOVE_NOTE, RemoveNoteCmd);
		mainModule.registerCmd(NoteMsg.UPDATE_NOTE, UpdateNoteCmd);
		mainModule.registerCmd(NoteMsg.GET_PAGE_INFO, GetPageInfoCmd);
		mainModule.registerCmd(NoteMsg.CLEAR_NOTES_INFO, ClearNotesInfoCmd);
		mainModule.registerCmd(NoteMsg.GET_THEMES, GetNoteThemesCmd);
		mainModule.registerCmd(NoteMsg.GET_EXAMPLES, GetNoteExamplesCmd);
		mainModule.registerCmd(NoteMsg.UPDATE_THEME, UpdateNoteThemeCmd);
		mainModule.registerCmd(NoteMsg.REMOVE_THEME, RemoveNoteThemeCmd);
		mainModule.registerCmd(NoteMsg.MERGE_THEMES, MergeNoteThemesCmd);
		mainModule.registerCmd(NoteMsg.GET_SELECTED_THEMES_ID, GetSelectedNoteThemesIDCmd);
		mainModule.registerCmd(NoteMsg.GET_NOTES_INFO, GetNotesInfoCmd);
		mainModule.registerCmd(NoteMsg.GET_NOTE_HASH, GetNoteHashCmd);

		//register models and services
		mainModule.registerProxy("settingsModel", new SettingsModel());
		mainModule.registerProxy("deferredOperationManager", new DeferredOperationManager());
		mainModule.registerProxy("screenFactory", new ScreenFactory());
		mainModule.registerProxy("screenMediatorFactory", new ScreenMediatorFactory());
		mainModule.registerProxy("screenModel", new ScreenModel());
		mainModule.registerProxy("toolTipManager", new CustomToolTipManager());

		//modules configuration
		var cmd:IConfigureCommand;
		var phraseModule:SFModule = new SFModule(ModuleName.PHRASE);
		(mainModule as RootModule).addModule(phraseModule);
		cmd = new ConfigurePhraseModuleCmd();
		cmd.execute(phraseModule);

		var wordModule:SFModule = new SFModule(ModuleName.WORD);
		(mainModule as RootModule).addModule(wordModule);
		cmd = new ConfigureWordModuleCmd();
		cmd.execute(wordModule);
	}
}
}