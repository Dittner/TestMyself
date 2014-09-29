package dittner.testmyself.core.model.note {
import dittner.satelliteFlight.proxy.SFProxy;

public class SQLFactory extends SFProxy {
	public function SQLFactory() {}

	//--------------------------------------
	//  create
	//--------------------------------------

	[Embed(source="/dittner/testmyself/core/command/backend/sql/CreateNoteTbl.sql", mimeType="application/octet-stream")]
	private static const CreateNoteTblClass:Class;
	private static const CREATE_NOTE_TBL_SQL:String = new CreateNoteTblClass();
	public function get createNoteTbl():String {
		return CREATE_NOTE_TBL_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/CreateThemeTbl.sql", mimeType="application/octet-stream")]
	private static const CreateThemeTblClass:Class;
	private static const CREATE_THEME_TBL_SQL:String = new CreateThemeTblClass();
	public function get createThemeTbl():String {
		return CREATE_THEME_TBL_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/CreateFilterTbl.sql", mimeType="application/octet-stream")]
	private static const CreateFilterTblClass:Class;
	private static const CREATE_FILTER_TBL_SQL:String = new CreateFilterTblClass();
	public function get createFilterTbl():String {
		return CREATE_FILTER_TBL_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/CreateExampleTbl.sql", mimeType="application/octet-stream")]
	private static const CreateExampleTblClass:Class;
	private static const CREATE_EXAMPLE_TBL_SQL:String = new CreateExampleTblClass();
	public function get createExampleTbl():String {
		return CREATE_EXAMPLE_TBL_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/CreateTestTbl.sql", mimeType="application/octet-stream")]
	private static const CreateTestTblClass:Class;
	private static const CREATE_TEST_TBL_SQL:String = new CreateTestTblClass();
	public function get createTestTbl():String {
		return CREATE_TEST_TBL_SQL;
	}

	//--------------------------------------
	//  insert
	//--------------------------------------

	[Embed(source="/dittner/testmyself/core/command/backend/sql/InsertNote.sql", mimeType="application/octet-stream")]
	private static const InsertNoteClass:Class;
	private static const INSERT_NOTE_SQL:String = new InsertNoteClass();
	public function get insertNote():String {
		return INSERT_NOTE_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/InsertTheme.sql", mimeType="application/octet-stream")]
	private static const InsertThemeClass:Class;
	private static const INSERT_THEME_SQL:String = new InsertThemeClass();
	public function get insertTheme():String {
		return INSERT_THEME_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/InsertFilter.sql", mimeType="application/octet-stream")]
	private static const InsertFilterClass:Class;
	private static const INSERT_FILTER_SQL:String = new InsertFilterClass();
	public function get insertFilter():String {
		return INSERT_FILTER_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/InsertExample.sql", mimeType="application/octet-stream")]
	private static const InsertExampleClass:Class;
	private static const INSERT_EXAMPLE_SQL:String = new InsertExampleClass();
	public function get insertExample():String {
		return INSERT_EXAMPLE_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/InsertTestTask.sql", mimeType="application/octet-stream")]
	private static const InsertTestTaskClass:Class;
	private static const INSERT_TEST_TASK_SQL:String = new InsertTestTaskClass();
	public function get insertTestTask():String {
		return INSERT_TEST_TASK_SQL;
	}

	//--------------------------------------
	//  update
	//--------------------------------------

	[Embed(source="/dittner/testmyself/core/command/backend/sql/UpdateNote.sql", mimeType="application/octet-stream")]
	private static const UpdateNoteClass:Class;
	private static const UPDATE_NOTE_SQL:String = new UpdateNoteClass();
	public function get updateNote():String {
		return UPDATE_NOTE_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/UpdateTheme.sql", mimeType="application/octet-stream")]
	private static const UpdateThemeClass:Class;
	private static const UPDATE_THEME_SQL:String = new UpdateThemeClass();
	public function get updateTheme():String {
		return UPDATE_THEME_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/UpdateFilter.sql", mimeType="application/octet-stream")]
	private static const UpdateFilterClass:Class;
	private static const UPDATE_FILTER_SQL:String = new UpdateFilterClass();
	public function get updateFilter():String {
		return UPDATE_FILTER_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/UpdateTestTask.sql", mimeType="application/octet-stream")]
	private static const UpdateTestTaskClass:Class;
	private static const UPDATE_TEST_TASK_SQL:String = new UpdateTestTaskClass();
	public function get updateTestTask():String {
		return UPDATE_TEST_TASK_SQL;
	}

	//--------------------------------------
	//  select
	//--------------------------------------

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectCountNote.sql", mimeType="application/octet-stream")]
	private static const SelectCountNoteClass:Class;
	private static const SELECT_COUNT_NOTE_SQL:String = new SelectCountNoteClass();
	public function get selectCountNote():String {
		return SELECT_COUNT_NOTE_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectCountNoteWithAudio.sql", mimeType="application/octet-stream")]
	private static const SelectCountNoteWithAudioClass:Class;
	private static const SELECT_COUNT_NOTE_WITH_AUDIO_SQL:String = new SelectCountNoteWithAudioClass();
	public function get selectCountNoteWithAudio():String {
		return SELECT_COUNT_NOTE_WITH_AUDIO_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectCountFilteredNote.sql", mimeType="application/octet-stream")]
	private static const SelectCountFilteredNoteClass:Class;
	private static const SELECT_COUNT_FILTERED_NOTE_SQL:String = new SelectCountFilteredNoteClass();
	public function get selectCountFilteredNote():String {
		return SELECT_COUNT_FILTERED_NOTE_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectCountExample.sql", mimeType="application/octet-stream")]
	private static const SelectCountExampleClass:Class;
	private static const SELECT_COUNT_EXAMPLE_SQL:String = new SelectCountExampleClass();
	public function get selectCountExample():String {
		return SELECT_COUNT_EXAMPLE_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectCountExampleWithAudio.sql", mimeType="application/octet-stream")]
	private static const SelectCountExampleWithAudioClass:Class;
	private static const SELECT_COUNT_EXAMPLE_WITH_AUDIO_SQL:String = new SelectCountExampleWithAudioClass();
	public function get selectCountExampleWithAudio():String {
		return SELECT_COUNT_EXAMPLE_WITH_AUDIO_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectNote.sql", mimeType="application/octet-stream")]
	private static const SelectNoteClass:Class;
	private static const SELECT_NOTE_SQL:String = new SelectNoteClass();
	public function get selectNote():String {
		return SELECT_NOTE_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectPageNotes.sql", mimeType="application/octet-stream")]
	private static const SelectPageNotesClass:Class;
	private static const SELECT_PAGE_NOTES_SQL:String = new SelectPageNotesClass();
	public function get selectPageNotes():String {
		return SELECT_PAGE_NOTES_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectPageTestTasks.sql", mimeType="application/octet-stream")]
	private static const SelectPageTestTasksClass:Class;
	private static const SELECT_PAGE_TEST_TASKS_SQL:String = new SelectPageTestTasksClass();
	public function get selectPageTestTasks():String {
		return SELECT_PAGE_TEST_TASKS_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectFilteredPageTestTasks.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageTestTasksClass:Class;
	private static const SELECT_FILTERED_PAGE_TEST_TASKS_SQL:String = new SelectFilteredPageTestTasksClass();
	public function get selectFilteredPageTestTasks():String {
		return SELECT_FILTERED_PAGE_TEST_TASKS_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectPageTestNotes.sql", mimeType="application/octet-stream")]
	private static const SelectPageTestNotesClass:Class;
	private static const SELECT_PAGE_TEST_NOTES_SQL:String = new SelectPageTestNotesClass();
	public function get selectPageTestNotes():String {
		return SELECT_PAGE_TEST_NOTES_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectFilteredPageTestNotes.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageTestNotesClass:Class;
	private static const SELECT_FILTERED_PAGE_TEST_NOTES_SQL:String = new SelectFilteredPageTestNotesClass();
	public function get selectFilteredPageTestNotes():String {
		return SELECT_FILTERED_PAGE_TEST_NOTES_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectNoteKeys.sql", mimeType="application/octet-stream")]
	private static const SelectNoteKeysClass:Class;
	private static const SELECT_NOTE_KEYS_SQL:String = new SelectNoteKeysClass();
	public function get selectNoteKeys():String {
		return SELECT_NOTE_KEYS_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectFilteredPageNotes.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageNotesClass:Class;
	private static const SELECT_FILTERED_PAGE_NOTES_SQL:String = new SelectFilteredPageNotesClass();
	public function get selectFilteredPageNotes():String {
		return SELECT_FILTERED_PAGE_NOTES_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectTheme.sql", mimeType="application/octet-stream")]
	private static const SelectThemeClass:Class;
	private static const SELECT_THEME_SQL:String = new SelectThemeClass();
	public function get selectTheme():String {
		return SELECT_THEME_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectFilter.sql", mimeType="application/octet-stream")]
	private static const SelectFilterClass:Class;
	private static const SELECT_FILTER_SQL:String = new SelectFilterClass();
	public function get selectFilter():String {
		return SELECT_FILTER_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectExample.sql", mimeType="application/octet-stream")]
	private static const SelectExampleClass:Class;
	private static const SELECT_EXAMPLE_SQL:String = new SelectExampleClass();
	public function get selectExample():String {
		return SELECT_EXAMPLE_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectTestNoteID.sql", mimeType="application/octet-stream")]
	private static const SelectTestNoteIDClass:Class;
	private static const SELECT_TEST_NOTE_ID_SQL:String = new SelectTestNoteIDClass();
	public function get selectTestNoteID():String {
		return SELECT_TEST_NOTE_ID_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectTestTaskClass:Class;
	private static const SELECT_TEST_TASK_SQL:String = new SelectTestTaskClass();
	public function get selectTestTask():String {
		return SELECT_TEST_TASK_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectFilteredTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredTestTaskClass:Class;
	private static const SELECT_FILTERED_TEST_TASK_SQL:String = new SelectFilteredTestTaskClass();
	public function get selectFilteredTestTask():String {
		return SELECT_FILTERED_TEST_TASK_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectCountTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectCountTestTaskClass:Class;
	private static const SELECT_COUNT_TEST_TASK_SQL:String = new SelectCountTestTaskClass();
	public function get selectCountTestTask():String {
		return SELECT_COUNT_TEST_TASK_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/SelectCountFilteredTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectCountFilteredTestTaskClass:Class;
	private static const SELECT_COUNT_FILTERED_TEST_TASK_SQL:String = new SelectCountFilteredTestTaskClass();
	public function get selectCountFilteredTestTask():String {
		return SELECT_COUNT_FILTERED_TEST_TASK_SQL;
	}

	//--------------------------------------
	//  delete
	//--------------------------------------

	[Embed(source="/dittner/testmyself/core/command/backend/sql/DeleteNote.sql", mimeType="application/octet-stream")]
	private static const DeleteNoteClass:Class;
	private static const DELETE_NOTE_SQL:String = new DeleteNoteClass();
	public function get deleteNote():String {
		return DELETE_NOTE_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/DeleteNotesByTheme.sql", mimeType="application/octet-stream")]
	private static const DeleteNotesByThemeClass:Class;
	private static const DELETE_NOTES_BY_THEME_SQL:String = new DeleteNotesByThemeClass();
	public function get deleteNotesByTheme():String {
		return DELETE_NOTES_BY_THEME_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/DeleteTheme.sql", mimeType="application/octet-stream")]
	private static const DeleteThemeClass:Class;
	private static const DELETE_THEME_SQL:String = new DeleteThemeClass();
	public function get deleteTheme():String {
		return DELETE_THEME_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/DeleteFilterByID.sql", mimeType="application/octet-stream")]
	private static const DeleteFilterByIDClass:Class;
	private static const DELETE_FILTER_BY_ID_SQL:String = new DeleteFilterByIDClass();
	public function get deleteFilterByID():String {
		return DELETE_FILTER_BY_ID_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/DeleteFilterByNoteID.sql", mimeType="application/octet-stream")]
	private static const DeleteFilterByNoteIDClass:Class;
	private static const DELETE_FILTER_BY_NOTE_ID_SQL:String = new DeleteFilterByNoteIDClass();
	public function get deleteFilterByNoteID():String {
		return DELETE_FILTER_BY_NOTE_ID_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/DeleteExampleByNoteID.sql", mimeType="application/octet-stream")]
	private static const DeleteExampleByNoteIDClass:Class;
	private static const DELETE_EXAMPLE_BY_NOTE_ID_SQL:String = new DeleteExampleByNoteIDClass();
	public function get deleteExampleByNoteID():String {
		return DELETE_EXAMPLE_BY_NOTE_ID_SQL;
	}

	[Embed(source="/dittner/testmyself/core/command/backend/sql/DeleteTestTaskByNoteID.sql", mimeType="application/octet-stream")]
	private static const DeleteTestTaskByNoteIDClass:Class;
	private static const DELETE_TEST_TASK_BY_NOTE_ID_SQL:String = new DeleteTestTaskByNoteIDClass();
	public function get deleteTestTaskByNoteID():String {
		return DELETE_TEST_TASK_BY_NOTE_ID_SQL;
	}

}
}
