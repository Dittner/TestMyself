package de.dittner.testmyself.backend.command.app {
import de.dittner.satelliteFlight.command.IConfigureCommand;
import de.dittner.satelliteFlight.module.RootModule;
import de.dittner.satelliteFlight.module.SFModule;
import de.dittner.testmyself.backend.command.AddNoteCmd;
import de.dittner.testmyself.backend.command.AddThemeCmd;
import de.dittner.testmyself.backend.command.ClearNotesInfoCmd;
import de.dittner.testmyself.backend.command.ClearTestHistoryCmd;
import de.dittner.testmyself.backend.command.GetNoteCmd;
import de.dittner.testmyself.backend.command.GetNoteExampleCmd;
import de.dittner.testmyself.backend.command.GetNoteExamplesCmd;
import de.dittner.testmyself.backend.command.GetNoteFilterCmd;
import de.dittner.testmyself.backend.command.GetNoteHashCmd;
import de.dittner.testmyself.backend.command.GetNotePageInfoCmd;
import de.dittner.testmyself.backend.command.GetNoteThemesCmd;
import de.dittner.testmyself.backend.command.GetNotesInfoCmd;
import de.dittner.testmyself.backend.command.GetSelectedNoteCmd;
import de.dittner.testmyself.backend.command.GetSelectedNoteThemesIDCmd;
import de.dittner.testmyself.backend.command.GetTestInfoListCmd;
import de.dittner.testmyself.backend.command.GetTestPageInfoCmd;
import de.dittner.testmyself.backend.command.GetTestSpecCmd;
import de.dittner.testmyself.backend.command.GetTestTasksAmountCmd;
import de.dittner.testmyself.backend.command.GetTestTasksCmd;
import de.dittner.testmyself.backend.command.MergeNoteThemesCmd;
import de.dittner.testmyself.backend.command.ReloadDataBaseCmd;
import de.dittner.testmyself.backend.command.RemoveNoteCmd;
import de.dittner.testmyself.backend.command.RemoveNoteExampleCmd;
import de.dittner.testmyself.backend.command.RemoveNoteThemeCmd;
import de.dittner.testmyself.backend.command.RemoveNotesByThemeCmd;
import de.dittner.testmyself.backend.command.SearchNotesCmd;
import de.dittner.testmyself.backend.command.SelectNoteCmd;
import de.dittner.testmyself.backend.command.SelectTestSpecCmd;
import de.dittner.testmyself.backend.command.SetNoteFilterCmd;
import de.dittner.testmyself.backend.command.UpdateNoteCmd;
import de.dittner.testmyself.backend.command.UpdateNoteExampleCmd;
import de.dittner.testmyself.backend.command.UpdateNoteThemeCmd;
import de.dittner.testmyself.backend.command.UpdateTestTaskCmd;
import de.dittner.testmyself.backend.command.backend.deferredOperation.DeferredCommandManager;
import de.dittner.testmyself.backend.command.screen.EditModeScreenCmd;
import de.dittner.testmyself.backend.command.screen.GetScreenInfoListCmd;
import de.dittner.testmyself.backend.command.screen.GetSelectedScreenCmd;
import de.dittner.testmyself.backend.command.screen.LockScreenCmd;
import de.dittner.testmyself.backend.command.screen.SelectScreenCmd;
import de.dittner.testmyself.backend.command.screen.UnlockScreenCmd;
import de.dittner.testmyself.backend.command.settings.LoadSettings;
import de.dittner.testmyself.backend.command.settings.StoreSettings;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.backend.message.TestMsg;
import de.dittner.testmyself.model.ModuleName;
import de.dittner.testmyself.model.screen.ScreenModel;
import de.dittner.testmyself.model.settings.SettingsModel;
import de.dittner.testmyself.ui.common.tooltip.CustomToolTipManager;
import de.dittner.testmyself.ui.message.ScreenMsg;
import de.dittner.testmyself.ui.message.SettingsMsg;
import de.dittner.testmyself.ui.service.screenFactory.ScreenFactory;
import de.dittner.testmyself.ui.service.screenMediatorFactory.ScreenMediatorFactory;

public class ConfigureMainModuleCmd implements IConfigureCommand {

	public function execute(mainModule:SFModule):void {
		//register commands
		mainModule.registerCmd(ScreenMsg.SELECT_SCREEN, SelectScreenCmd);
		mainModule.registerCmd(ScreenMsg.GET_SELECTED_SCREEN, GetSelectedScreenCmd);
		mainModule.registerCmd(ScreenMsg.GET_SCREEN_INFO_LIST, GetScreenInfoListCmd);
		mainModule.registerCmd(ScreenMsg.EDIT, EditModeScreenCmd);
		mainModule.registerCmd(ScreenMsg.LOCK, LockScreenCmd);
		mainModule.registerCmd(ScreenMsg.UNLOCK, UnlockScreenCmd);
		mainModule.registerCmd(SettingsMsg.LOAD, LoadSettings);
		mainModule.registerCmd(SettingsMsg.STORE, StoreSettings);
		mainModule.registerCmd(SettingsMsg.RELOAD_DB, ReloadDataBaseCmd);
		mainModule.registerCmd(TestMsg.GET_TEST_INFO_LIST, GetTestInfoListCmd);
		mainModule.registerCmd(TestMsg.GET_TEST_SPEC, GetTestSpecCmd);
		mainModule.registerCmd(TestMsg.SELECT_TEST_SPEC, SelectTestSpecCmd);

		//common note commands
		mainModule.registerCmd(NoteMsg.SELECT_NOTE, SelectNoteCmd);
		mainModule.registerCmd(NoteMsg.GET_SELECTED_NOTE, GetSelectedNoteCmd);
		mainModule.registerCmd(NoteMsg.GET_FILTER, GetNoteFilterCmd);
		mainModule.registerCmd(NoteMsg.SET_FILTER, SetNoteFilterCmd);

		/*sql*/
		mainModule.registerCmd(NoteMsg.ADD_NOTE, AddNoteCmd);
		mainModule.registerCmd(NoteMsg.ADD_THEME, AddThemeCmd);
		mainModule.registerCmd(NoteMsg.REMOVE_NOTE, RemoveNoteCmd);
		mainModule.registerCmd(NoteMsg.REMOVE_NOTES_BY_THEME, RemoveNotesByThemeCmd);
		mainModule.registerCmd(NoteMsg.UPDATE_NOTE, UpdateNoteCmd);
		mainModule.registerCmd(NoteMsg.GET_NOTE_PAGE_INFO, GetNotePageInfoCmd);
		mainModule.registerCmd(NoteMsg.CLEAR_NOTES_INFO, ClearNotesInfoCmd);
		mainModule.registerCmd(NoteMsg.GET_THEMES, GetNoteThemesCmd);
		mainModule.registerCmd(NoteMsg.GET_EXAMPLES, GetNoteExamplesCmd);
		mainModule.registerCmd(NoteMsg.GET_EXAMPLE, GetNoteExampleCmd);
		mainModule.registerCmd(NoteMsg.UPDATE_EXAMPLE, UpdateNoteExampleCmd);
		mainModule.registerCmd(NoteMsg.UPDATE_THEME, UpdateNoteThemeCmd);
		mainModule.registerCmd(NoteMsg.REMOVE_THEME, RemoveNoteThemeCmd);
		mainModule.registerCmd(NoteMsg.REMOVE_EXAMPLE, RemoveNoteExampleCmd);
		mainModule.registerCmd(NoteMsg.MERGE_THEMES, MergeNoteThemesCmd);
		mainModule.registerCmd(NoteMsg.GET_SELECTED_THEMES_ID, GetSelectedNoteThemesIDCmd);
		mainModule.registerCmd(NoteMsg.GET_NOTE, GetNoteCmd);
		mainModule.registerCmd(NoteMsg.GET_NOTES_INFO, GetNotesInfoCmd);
		mainModule.registerCmd(NoteMsg.GET_NOTE_HASH, GetNoteHashCmd);
		mainModule.registerCmd(NoteMsg.SEARCH_NOTES, SearchNotesCmd);

		mainModule.registerCmd(TestMsg.GET_TEST_TASKS, GetTestTasksCmd);
		mainModule.registerCmd(TestMsg.GET_TEST_PAGE_INFO, GetTestPageInfoCmd);
		mainModule.registerCmd(TestMsg.GET_TEST_TASKS_AMOUNT, GetTestTasksAmountCmd);
		mainModule.registerCmd(TestMsg.UPDATE_TEST_TASK, UpdateTestTaskCmd);
		mainModule.registerCmd(TestMsg.CLEAR_TEST_HISTORY, ClearTestHistoryCmd);

		//register models and services
		mainModule.registerProxy("settingsModel", new SettingsModel());
		mainModule.registerProxy("deferredCommandManager", new DeferredCommandManager());
		mainModule.registerProxy("screenFactory", new ScreenFactory());
		mainModule.registerProxy("screenMediatorFactory", new ScreenMediatorFactory());
		mainModule.registerProxy("screenModel", new ScreenModel());
		mainModule.registerProxy("toolTipManager", new CustomToolTipManager());

		//modules configuration
		var cmd:IConfigureCommand;

		var wordModule:SFModule = new SFModule(ModuleName.WORD);
		(mainModule as RootModule).addModule(wordModule);
		cmd = new ConfigureWordModuleCmd();
		cmd.execute(wordModule);

		var verbModule:SFModule = new SFModule(ModuleName.VERB);
		(mainModule as RootModule).addModule(verbModule);
		cmd = new ConfigureVerbModuleCmd();
		cmd.execute(verbModule);

		var lessonModule:SFModule = new SFModule(ModuleName.LESSON);
		(mainModule as RootModule).addModule(lessonModule);
		cmd = new ConfigureLessonModuleCmd();
		cmd.execute(lessonModule);
	}
}
}