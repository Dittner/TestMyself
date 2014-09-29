package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.RootModule;
import dittner.satelliteFlight.module.SFModule;
import dittner.testmyself.core.command.AddNoteCmd;
import dittner.testmyself.core.command.AddThemeCmd;
import dittner.testmyself.core.command.ClearNotesInfoCmd;
import dittner.testmyself.core.command.ClearTestHistoryCmd;
import dittner.testmyself.core.command.GetNoteCmd;
import dittner.testmyself.core.command.GetNoteExamplesCmd;
import dittner.testmyself.core.command.GetNoteFilterCmd;
import dittner.testmyself.core.command.GetNoteHashCmd;
import dittner.testmyself.core.command.GetNotePageInfoCmd;
import dittner.testmyself.core.command.GetNoteThemesCmd;
import dittner.testmyself.core.command.GetNotesInfoCmd;
import dittner.testmyself.core.command.GetSelectedNoteCmd;
import dittner.testmyself.core.command.GetSelectedNoteThemesIDCmd;
import dittner.testmyself.core.command.GetTestInfoListCmd;
import dittner.testmyself.core.command.GetTestPageInfoCmd;
import dittner.testmyself.core.command.GetTestSpecCmd;
import dittner.testmyself.core.command.GetTestTasksAmountCmd;
import dittner.testmyself.core.command.GetTestTasksCmd;
import dittner.testmyself.core.command.MergeNoteThemesCmd;
import dittner.testmyself.core.command.RemoveNoteCmd;
import dittner.testmyself.core.command.RemoveNoteThemeCmd;
import dittner.testmyself.core.command.RemoveNotesByThemeCmd;
import dittner.testmyself.core.command.SelectNoteCmd;
import dittner.testmyself.core.command.SelectTestSpecCmd;
import dittner.testmyself.core.command.SetNoteFilterCmd;
import dittner.testmyself.core.command.UpdateNoteCmd;
import dittner.testmyself.core.command.UpdateNoteThemeCmd;
import dittner.testmyself.core.command.UpdateTestTaskCmd;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperationManager;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.TestMsg;
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
		mainModule.registerCmd(NoteMsg.UPDATE_THEME, UpdateNoteThemeCmd);
		mainModule.registerCmd(NoteMsg.REMOVE_THEME, RemoveNoteThemeCmd);
		mainModule.registerCmd(NoteMsg.MERGE_THEMES, MergeNoteThemesCmd);
		mainModule.registerCmd(NoteMsg.GET_SELECTED_THEMES_ID, GetSelectedNoteThemesIDCmd);
		mainModule.registerCmd(NoteMsg.GET_NOTE, GetNoteCmd);
		mainModule.registerCmd(NoteMsg.GET_NOTES_INFO, GetNotesInfoCmd);
		mainModule.registerCmd(NoteMsg.GET_NOTE_HASH, GetNoteHashCmd);
		mainModule.registerCmd(TestMsg.GET_TEST_TASKS, GetTestTasksCmd);
		mainModule.registerCmd(TestMsg.GET_TEST_PAGE_INFO, GetTestPageInfoCmd);
		mainModule.registerCmd(TestMsg.GET_TEST_TASKS_AMOUNT, GetTestTasksAmountCmd);
		mainModule.registerCmd(TestMsg.UPDATE_TEST_TASK, UpdateTestTaskCmd);
		mainModule.registerCmd(TestMsg.CLEAR_TEST_HISTORY, ClearTestHistoryCmd);

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