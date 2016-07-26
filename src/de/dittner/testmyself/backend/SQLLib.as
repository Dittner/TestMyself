package de.dittner.testmyself.backend {
public class SQLLib {
	public function SQLLib() {}

	//--------------------------------------
	//  create
	//--------------------------------------

	public static const TABLES:Array = [CREATE_NOTE_TBL_SQL, CREATE_THEME_TBL_SQL, CREATE_FILTER_TBL_SQL, CREATE_TEST_TBL_SQL];

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateNoteTbl.sql", mimeType="application/octet-stream")]
	private static const CreateNoteTblClass:Class;
	public static const CREATE_NOTE_TBL_SQL:String = new CreateNoteTblClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateThemeTbl.sql", mimeType="application/octet-stream")]
	private static const CreateThemeTblClass:Class;
	public static const CREATE_THEME_TBL_SQL:String = new CreateThemeTblClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateFilterTbl.sql", mimeType="application/octet-stream")]
	private static const CreateFilterTblClass:Class;
	public static const CREATE_FILTER_TBL_SQL:String = new CreateFilterTblClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateTestTbl.sql", mimeType="application/octet-stream")]
	private static const CreateTestTblClass:Class;
	public static const CREATE_TEST_TBL_SQL:String = new CreateTestTblClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/AddColumnInTestTable.sql", mimeType="application/octet-stream")]
	private static const AddColumnInTestTblClass:Class;
	public static const ADD_COLUMN_IN_TEST_TBL:String = new AddColumnInTestTblClass();

	//--------------------------------------
	//  insert
	//--------------------------------------

	[Embed(source="/de/dittner/testmyself/backend/sql/InsertNote.sql", mimeType="application/octet-stream")]
	private static const InsertNoteClass:Class;
	public static const INSERT_NOTE_SQL:String = new InsertNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/InsertTheme.sql", mimeType="application/octet-stream")]
	private static const InsertThemeClass:Class;
	public static const INSERT_THEME_SQL:String = new InsertThemeClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/InsertFilter.sql", mimeType="application/octet-stream")]
	private static const InsertFilterClass:Class;
	public static const INSERT_FILTER_SQL:String = new InsertFilterClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/InsertTestTask.sql", mimeType="application/octet-stream")]
	private static const InsertTestTaskClass:Class;
	public static const INSERT_TEST_TASK_SQL:String = new InsertTestTaskClass();

	//--------------------------------------
	//  update
	//--------------------------------------

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateNote.sql", mimeType="application/octet-stream")]
	private static const UpdateNoteClass:Class;
	public static const UPDATE_NOTE_SQL:String = new UpdateNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateNoteExample.sql", mimeType="application/octet-stream")]
	private static const UpdateNoteExampleClass:Class;
	public static const UPDATE_NOTE_EXAMPLE_SQL:String = new UpdateNoteExampleClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateTheme.sql", mimeType="application/octet-stream")]
	private static const UpdateThemeClass:Class;
	public static const UPDATE_THEME_SQL:String = new UpdateThemeClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateFilter.sql", mimeType="application/octet-stream")]
	private static const UpdateFilterClass:Class;
	public static const UPDATE_FILTER_SQL:String = new UpdateFilterClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateTestTask.sql", mimeType="application/octet-stream")]
	private static const UpdateTestTaskClass:Class;
	public static const UPDATE_TEST_TASK_SQL:String = new UpdateTestTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateTestExampleTask.sql", mimeType="application/octet-stream")]
	private static const UpdateTestExampleTaskClass:Class;
	public static const UPDATE_TEST_EXAMPLE_TASK_SQL:String = new UpdateTestExampleTaskClass();

	//--------------------------------------
	//  select
	//--------------------------------------

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountNote.sql", mimeType="application/octet-stream")]
	private static const SelectCountNoteClass:Class;
	public static const SELECT_COUNT_NOTE_SQL:String = new SelectCountNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountAudioComment.sql", mimeType="application/octet-stream")]
	private static const SelectCountAudioComment:Class;
	public static const SELECT_COUNT_AUDIO_COMMENT_SQL:String = new SelectCountAudioComment();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountFilteredNote.sql", mimeType="application/octet-stream")]
	private static const SelectCountFilteredNoteClass:Class;
	public static const SELECT_COUNT_FILTERED_NOTE_SQL:String = new SelectCountFilteredNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountNotesBySearch.sql", mimeType="application/octet-stream")]
	private static const SelectCountNotesBySearchClass:Class;
	public static const SELECT_COUNT_NOTES_BY_SEARCH_SQL:String = new SelectCountNotesBySearchClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountExample.sql", mimeType="application/octet-stream")]
	private static const SelectCountExampleClass:Class;
	public static const SELECT_COUNT_EXAMPLE_SQL:String = new SelectCountExampleClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountExampleWithAudio.sql", mimeType="application/octet-stream")]
	private static const SelectCountExampleWithAudioClass:Class;
	public static const SELECT_COUNT_EXAMPLE_WITH_AUDIO_SQL:String = new SelectCountExampleWithAudioClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectNote.sql", mimeType="application/octet-stream")]
	private static const SelectNoteClass:Class;
	public static const SELECT_NOTE_SQL:String = new SelectNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectNotesIDs.sql", mimeType="application/octet-stream")]
	private static const SearchNotesClass:Class;
	public static const SEARCH_NOTES_SQL:String = new SearchNotesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectNotesIDsByTheme.sql", mimeType="application/octet-stream")]
	private static const SelectNotesIDsByThemeClass:Class;
	public static const SELECT_NOTES_IDS_BY_THEME_SQL:String = new SelectNotesIDsByThemeClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectNoteExamplesIDs.sql", mimeType="application/octet-stream")]
	private static const SearchNoteExampleClass:Class;
	public static const SEARCH_NOTE_EXAMPLE_SQL:String = new SearchNoteExampleClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectPageNotes.sql", mimeType="application/octet-stream")]
	private static const SelectPageNotesClass:Class;
	public static const SELECT_PAGE_NOTES_SQL:String = new SelectPageNotesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectPageTestTasks.sql", mimeType="application/octet-stream")]
	private static const SelectPageTestTasksClass:Class;
	public static const SELECT_PAGE_TEST_TASKS_SQL:String = new SelectPageTestTasksClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectPageTestExampleTasks.sql", mimeType="application/octet-stream")]
	private static const SelectPageTestExampleTasksClass:Class;
	public static const SELECT_PAGE_TEST_EXAMPLE_TASKS_SQL:String = new SelectPageTestExampleTasksClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredPageTestTasks.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageTestTasksClass:Class;
	public static const SELECT_FILTERED_PAGE_TEST_TASKS_SQL:String = new SelectFilteredPageTestTasksClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredPageTestExampleTasks.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageTestExampleTasksClass:Class;
	public static const SELECT_FILTERED_PAGE_TEST_EXAMPLE_TASKS_SQL:String = new SelectFilteredPageTestExampleTasksClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectPageTestNotes.sql", mimeType="application/octet-stream")]
	private static const SelectPageTestNotesClass:Class;
	public static const SELECT_PAGE_TEST_NOTES_SQL:String = new SelectPageTestNotesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectPageTestExamples.sql", mimeType="application/octet-stream")]
	private static const SelectPageTestExamplesClass:Class;
	public static const SELECT_PAGE_TEST_EXAMPLES_SQL:String = new SelectPageTestExamplesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredPageTestNotes.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageTestNotesClass:Class;
	public static const SELECT_FILTERED_PAGE_TEST_NOTES_SQL:String = new SelectFilteredPageTestNotesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredPageTestExamples.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageTestExamplesClass:Class;
	public static const SELECT_FILTERED_PAGE_TEST_EXAMPLES_SQL:String = new SelectFilteredPageTestExamplesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectAllNotesTitles.sql", mimeType="application/octet-stream")]
	private static const SelectAllNotesTitlesClass:Class;
	public static const SELECT_ALL_NOTES_TITLES_SQL:String = new SelectAllNotesTitlesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredPageNotes.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageNotesClass:Class;
	public static const SELECT_FILTERED_PAGE_NOTES_SQL:String = new SelectFilteredPageNotesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectTheme.sql", mimeType="application/octet-stream")]
	private static const SelectThemeClass:Class;
	public static const SELECT_THEME_SQL:String = new SelectThemeClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilter.sql", mimeType="application/octet-stream")]
	private static const SelectFilterClass:Class;
	public static const SELECT_FILTER_SQL:String = new SelectFilterClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectNoteThemes.sql", mimeType="application/octet-stream")]
	private static const SelectNoteThemesClass:Class;
	public static const SELECT_NOTE_THEMES_SQL:String = new SelectNoteThemesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectExampleByParentID.sql", mimeType="application/octet-stream")]
	private static const SelectExampleByParentIDClass:Class;
	public static const SELECT_EXAMPLE_BY_PARENT_ID_SQL:String = new SelectExampleByParentIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectExampleByID.sql", mimeType="application/octet-stream")]
	private static const SelectExampleByIDClass:Class;
	public static const SELECT_EXAMPLE_BY_ID_SQL:String = new SelectExampleByIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectTestNoteID.sql", mimeType="application/octet-stream")]
	private static const SelectTestNoteIDClass:Class;
	public static const SELECT_TEST_NOTE_ID_SQL:String = new SelectTestNoteIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectTestTaskClass:Class;
	public static const SELECT_TEST_TASK_SQL:String = new SelectTestTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectTestExampleTask.sql", mimeType="application/octet-stream")]
	private static const SelectTestExampleTaskClass:Class;
	public static const SELECT_TEST_EXAMPLE_TASK_SQL:String = new SelectTestExampleTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredTestTaskClass:Class;
	public static const SELECT_FILTERED_TEST_TASK_SQL:String = new SelectFilteredTestTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredTestExampleTask.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredTestExampleTaskClass:Class;
	public static const SELECT_FILTERED_TEST_EXAMPLE_TASK_SQL:String = new SelectFilteredTestExampleTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectCountTestTaskClass:Class;
	public static const SELECT_COUNT_TEST_TASK_SQL:String = new SelectCountTestTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountTestExampleTask.sql", mimeType="application/octet-stream")]
	private static const SelectCountTestExampleTaskClass:Class;
	public static const SELECT_COUNT_TEST_EXAMPLE_TASK_SQL:String = new SelectCountTestExampleTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountFilteredTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectCountFilteredTestTaskClass:Class;
	public static const SELECT_COUNT_FILTERED_TEST_TASK_SQL:String = new SelectCountFilteredTestTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountFilteredTestExampleTask.sql", mimeType="application/octet-stream")]
	private static const SelectCountFilteredTestExampleTaskClass:Class;
	public static const SELECT_COUNT_FILTERED_TEST_EXAMPLE_TASK_SQL:String = new SelectCountFilteredTestExampleTaskClass();

	//--------------------------------------
	//  delete
	//--------------------------------------

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteNote.sql", mimeType="application/octet-stream")]
	private static const DeleteNoteClass:Class;
	public static const DELETE_NOTE_SQL:String = new DeleteNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteTheme.sql", mimeType="application/octet-stream")]
	private static const DeleteThemeClass:Class;
	public static const DELETE_THEME_SQL:String = new DeleteThemeClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteFilterByID.sql", mimeType="application/octet-stream")]
	private static const DeleteFilterByIDClass:Class;
	public static const DELETE_FILTER_BY_ID_SQL:String = new DeleteFilterByIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteFilterByNoteID.sql", mimeType="application/octet-stream")]
	private static const DeleteFilterByNoteIDClass:Class;
	public static const DELETE_FILTER_BY_NOTE_ID_SQL:String = new DeleteFilterByNoteIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteExampleByParentID.sql", mimeType="application/octet-stream")]
	private static const DeleteExampleByParentIDClass:Class;
	public static const DELETE_EXAMPLE_BY_PARENT_ID_SQL:String = new DeleteExampleByParentIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteExampleByID.sql", mimeType="application/octet-stream")]
	private static const DeleteExampleByIDClass:Class;
	public static const DELETE_EXAMPLE_BY_ID_SQL:String = new DeleteExampleByIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteTestTaskByNoteID.sql", mimeType="application/octet-stream")]
	private static const DeleteTestTaskByNoteIDClass:Class;
	public static const DELETE_TEST_TASK_BY_NOTE_ID_SQL:String = new DeleteTestTaskByNoteIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteTestTaskByParentID.sql", mimeType="application/octet-stream")]
	private static const DeleteTestTaskByParentIDClass:Class;
	public static const DELETE_TEST_TASK_BY_PARENT_ID_SQL:String = new DeleteTestTaskByParentIDClass();


}
}
