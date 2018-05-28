package de.dittner.testmyself.backend {
public class SQLLib {
	public function SQLLib() {}

	//--------------------------------------
	//  create
	//--------------------------------------

	public static function getNoteDBTables():Array {
		return [CREATE_NOTE_TBL_SQL, CREATE_TAG_TBL_SQL, CREATE_TEST_TBL_SQL, CREATE_AUDIO_TBL_SQL, CREATE_HASH_TBL_SQL];
	}

	public static function getAudioDBTables():Array {
		return [CREATE_AUDIO_TBL_SQL];
	}

	public static function getEnRuDicDBTables():Array {
		return [CREATE_RU_EN_TBL_SQL];
	}

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateNoteTbl.sql", mimeType="application/octet-stream")]
	private static const CreateNoteTblClass:Class;
	public static const CREATE_NOTE_TBL_SQL:String = new CreateNoteTblClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateTagTbl.sql", mimeType="application/octet-stream")]
	private static const CreateTagTblClass:Class;
	public static const CREATE_TAG_TBL_SQL:String = new CreateTagTblClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateTestTbl.sql", mimeType="application/octet-stream")]
	private static const CreateTestTblClass:Class;
	public static const CREATE_TEST_TBL_SQL:String = new CreateTestTblClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateAudioTbl.sql", mimeType="application/octet-stream")]
	private static const CreateAudioTblClass:Class;
	public static const CREATE_AUDIO_TBL_SQL:String = new CreateAudioTblClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateEnRuDicTbl.sql", mimeType="application/octet-stream")]
	private static const CreateEnRuDicTblClass:Class;
	public static const CREATE_RU_EN_TBL_SQL:String = new CreateEnRuDicTblClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/CreateHashTbl.sql", mimeType="application/octet-stream")]
	private static const CreateHashTblClass:Class;
	public static const CREATE_HASH_TBL_SQL:String = new CreateHashTblClass();

	//--------------------------------------
	//  insert
	//--------------------------------------

	[Embed(source="/de/dittner/testmyself/backend/sql/InsertNote.sql", mimeType="application/octet-stream")]
	private static const InsertNoteClass:Class;
	public static const INSERT_NOTE_SQL:String = new InsertNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/InsertAudio.sql", mimeType="application/octet-stream")]
	private static const InsertAudioClass:Class;
	public static const INSERT_AUDIO_SQL:String = new InsertAudioClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/InsertTag.sql", mimeType="application/octet-stream")]
	private static const InsertTagClass:Class;
	public static const INSERT_TAG_SQL:String = new InsertTagClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/InsertTestTask.sql", mimeType="application/octet-stream")]
	private static const InsertTestTaskClass:Class;
	public static const INSERT_TEST_TASK_SQL:String = new InsertTestTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/InsertHashData.sql", mimeType="application/octet-stream")]
	private static const InsertHashDataClass:Class;
	public static const INSERT_HASH_DATA_SQL:String = new InsertHashDataClass();

	//--------------------------------------
	//  update
	//--------------------------------------

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateNote.sql", mimeType="application/octet-stream")]
	private static const UpdateNoteClass:Class;
	public static const UPDATE_NOTE_SQL:String = new UpdateNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateTag.sql", mimeType="application/octet-stream")]
	private static const UpdateTagClass:Class;
	public static const UPDATE_TAG_SQL:String = new UpdateTagClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateTestTaskByNoteID.sql", mimeType="application/octet-stream")]
	private static const UpdateTestTaskByNoteIDClass:Class;
	public static const UPDATE_TEST_TASK_BY_NOTE_ID_SQL:String = new UpdateTestTaskByNoteIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateTestTask.sql", mimeType="application/octet-stream")]
	private static const UpdateTestTaskClass:Class;
	public static const UPDATE_TEST_TASK_SQL:String = new UpdateTestTaskClass();


	[Embed(source="/de/dittner/testmyself/backend/sql/UpdateHashData.sql", mimeType="application/octet-stream")]
	private static const UpdateHashDataClass:Class;
	public static const UPDATE_HASH_DATA_SQL:String = new UpdateHashDataClass();

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

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectNote.sql", mimeType="application/octet-stream")]
	private static const SelectNoteClass:Class;
	public static const SELECT_NOTE_SQL:String = new SelectNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectNotesBySearch.sql", mimeType="application/octet-stream")]
	private static const SearchNotesClass:Class;
	public static const SEARCH_NOTES_SQL:String = new SearchNotesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectNotesByFilteredSearch.sql", mimeType="application/octet-stream")]
	private static const SearchFilteredNotesClass:Class;
	public static const SEARCH_FILTERED_NOTES_SQL:String = new SearchFilteredNotesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectNotesIDsByTag.sql", mimeType="application/octet-stream")]
	private static const SelectNotesIDsByTagClass:Class;
	public static const SELECT_NOTES_IDS_BY_TAG_SQL:String = new SelectNotesIDsByTagClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectPageNotes.sql", mimeType="application/octet-stream")]
	private static const SelectPageNotesClass:Class;
	public static const SELECT_PAGE_NOTES_SQL:String = new SelectPageNotesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectPageTestTasks.sql", mimeType="application/octet-stream")]
	private static const SelectPageTestTasksClass:Class;
	public static const SELECT_PAGE_TEST_TASKS_SQL:String = new SelectPageTestTasksClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectTestTaskIDs.sql", mimeType="application/octet-stream")]
	private static const SelectTestTaskIDsClass:Class;
	public static const SELECT_TEST_TASK_IDS_SQL:String = new SelectTestTaskIDsClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectTestTaskByID.sql", mimeType="application/octet-stream")]
	private static const SelectTestTaskByIdClass:Class;
	public static const SELECT_TEST_TASK_BY_ID_SQL:String = new SelectTestTaskByIdClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredTestTaskIDs.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredTestTaskIDsClass:Class;
	public static const SELECT_FILTERED_TEST_TASK_IDS_SQL:String = new SelectFilteredTestTaskIDsClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredPageTestTasks.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageTestTasksClass:Class;
	public static const SELECT_FILTERED_PAGE_TEST_TASKS_SQL:String = new SelectFilteredPageTestTasksClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectAllNotesTitles.sql", mimeType="application/octet-stream")]
	private static const SelectAllNotesTitlesClass:Class;
	public static const SELECT_ALL_NOTES_TITLES_SQL:String = new SelectAllNotesTitlesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectAllExamples.sql", mimeType="application/octet-stream")]
	private static const SelectAllExamplesClass:Class;
	public static const SELECT_ALL_EXAMPLES_SQL:String = new SelectAllExamplesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectFilteredPageNotes.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPageNotesClass:Class;
	public static const SELECT_FILTERED_PAGE_NOTES_SQL:String = new SelectFilteredPageNotesClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectTag.sql", mimeType="application/octet-stream")]
	private static const SelectTagClass:Class;
	public static const SELECT_TAG_SQL:String = new SelectTagClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectCountTestTaskClass:Class;
	public static const SELECT_COUNT_TEST_TASK_SQL:String = new SelectCountTestTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectAudioComment.sql", mimeType="application/octet-stream")]
	private static const SelectAudioCommentClass:Class;
	public static const SELECT_AUDIO_COMMENT_SQL:String = new SelectAudioCommentClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectCountFilteredTestTask.sql", mimeType="application/octet-stream")]
	private static const SelectCountFilteredTestTaskClass:Class;
	public static const SELECT_COUNT_FILTERED_TEST_TASK_SQL:String = new SelectCountFilteredTestTaskClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectHashData.sql", mimeType="application/octet-stream")]
	private static const SelectHashDataClass:Class;
	public static const SELECT_HASH_DATA_SQL:String = new SelectHashDataClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/SelectEnRuDicNote.sql", mimeType="application/octet-stream")]
	private static const SelectEnRuDicNoteClass:Class;
	public static const SELECT_EN_RU_DIC_NOTE_SQL:String = new SelectEnRuDicNoteClass();

	//--------------------------------------
	//  delete
	//--------------------------------------

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteNote.sql", mimeType="application/octet-stream")]
	private static const DeleteNoteClass:Class;
	public static const DELETE_NOTE_SQL:String = new DeleteNoteClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteTag.sql", mimeType="application/octet-stream")]
	private static const DeleteTagClass:Class;
	public static const DELETE_TAG_SQL:String = new DeleteTagClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteExampleByParentID.sql", mimeType="application/octet-stream")]
	private static const DeleteExampleByParentIDClass:Class;
	public static const DELETE_EXAMPLE_BY_PARENT_ID_SQL:String = new DeleteExampleByParentIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteAudioCommentByParentNoteID.sql", mimeType="application/octet-stream")]
	private static const DeleteAudioCommentByParentNoteIDClass:Class;
	public static const DELETE_AUDIO_COMMENT_BY_PARENT_NOTE_ID_SQL:String = new DeleteAudioCommentByParentNoteIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteAudioCommentByNoteID.sql", mimeType="application/octet-stream")]
	private static const DeleteAudioCommentByNoteIDClass:Class;
	public static const DELETE_AUDIO_COMMENT_BY_NOTE_ID_SQL:String = new DeleteAudioCommentByNoteIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteTestTaskByNoteID.sql", mimeType="application/octet-stream")]
	private static const DeleteTestTaskByNoteIDClass:Class;
	public static const DELETE_TEST_TASK_BY_NOTE_ID_SQL:String = new DeleteTestTaskByNoteIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteTestTaskByParentID.sql", mimeType="application/octet-stream")]
	private static const DeleteTestTaskByParentIDClass:Class;
	public static const DELETE_TEST_TASK_BY_PARENT_ID_SQL:String = new DeleteTestTaskByParentIDClass();

	[Embed(source="/de/dittner/testmyself/backend/sql/DeleteTestTaskByID.sql", mimeType="application/octet-stream")]
	private static const DeleteTestTaskByIDClass:Class;
	public static const DELETE_TEST_TASK_BY_ID_SQL:String = new DeleteTestTaskByIDClass();

}
}
