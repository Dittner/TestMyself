package dittner.testmyself.command.backend.utils {
public class SQLFactory {
	public function SQLFactory() {}

	//--------------------------------------
	//  create
	//--------------------------------------

	[Embed(source="/dittner/testmyself/command/backend/sql/CreateTransUnitTbl.sql", mimeType="application/octet-stream")]
	private static const CreateTransUnitTblClass:Class;
	private static const CREATE_TRANS_UNIT_TBL_SQL:String = new CreateTransUnitTblClass();
	public function get createTransUnitTbl():String {
		return CREATE_TRANS_UNIT_TBL_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/CreateThemeTbl.sql", mimeType="application/octet-stream")]
	private static const CreateThemeTblClass:Class;
	private static const CREATE_THEME_TBL_SQL:String = new CreateThemeTblClass();
	public function get createThemeTbl():String {
		return CREATE_THEME_TBL_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/CreateFilterTbl.sql", mimeType="application/octet-stream")]
	private static const CreateFilterTblClass:Class;
	private static const CREATE_FILTER_TBL_SQL:String = new CreateFilterTblClass();
	public function get createFilterTbl():String {
		return CREATE_FILTER_TBL_SQL;
	}

	//--------------------------------------
	//  insert
	//--------------------------------------

	[Embed(source="/dittner/testmyself/command/backend/sql/InsertTransUnit.sql", mimeType="application/octet-stream")]
	private static const InsertTransUnitClass:Class;
	private static const INSERT_TRANS_UNIT_SQL:String = new InsertTransUnitClass();
	public function get insertTransUnit():String {
		return INSERT_TRANS_UNIT_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/InsertTheme.sql", mimeType="application/octet-stream")]
	private static const InsertThemeClass:Class;
	private static const INSERT_THEME_SQL:String = new InsertThemeClass();
	public function get insertTheme():String {
		return INSERT_THEME_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/InsertFilter.sql", mimeType="application/octet-stream")]
	private static const InsertFilterClass:Class;
	private static const INSERT_FILTER_SQL:String = new InsertFilterClass();
	public function get insertFilter():String {
		return INSERT_FILTER_SQL;
	}

	//--------------------------------------
	//  update
	//--------------------------------------

	[Embed(source="/dittner/testmyself/command/backend/sql/UpdateTransUnit.sql", mimeType="application/octet-stream")]
	private static const UpdateTransUnitClass:Class;
	private static const UPDATE_TRANS_UNIT_SQL:String = new UpdateTransUnitClass();
	public function get updateTransUnit():String {
		return UPDATE_TRANS_UNIT_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/UpdateTheme.sql", mimeType="application/octet-stream")]
	private static const UpdateThemeClass:Class;
	private static const UPDATE_THEME_SQL:String = new UpdateThemeClass();
	public function get updateTheme():String {
		return UPDATE_THEME_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/UpdateFilter.sql", mimeType="application/octet-stream")]
	private static const UpdateFilterClass:Class;
	private static const UPDATE_FILTER_SQL:String = new UpdateFilterClass();
	public function get updateFilter():String {
		return UPDATE_FILTER_SQL;
	}

	//--------------------------------------
	//  select
	//--------------------------------------

	[Embed(source="/dittner/testmyself/command/backend/sql/SelectCountTransUnit.sql", mimeType="application/octet-stream")]
	private static const SelectCountTransUnitClass:Class;
	private static const SELECT_COUNT_TRANS_UNIT_SQL:String = new SelectCountTransUnitClass();
	public function get selectCountTransUnit():String {
		return SELECT_COUNT_TRANS_UNIT_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/SelectCountTransUnitWithAudio.sql", mimeType="application/octet-stream")]
	private static const SelectCountTransUnitWithAudioClass:Class;
	private static const SELECT_COUNT_TRANS_UNIT_WITH_AUDIO_SQL:String = new SelectCountTransUnitWithAudioClass();
	public function get selectCountTransUnitWithAudio():String {
		return SELECT_COUNT_TRANS_UNIT_WITH_AUDIO_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/SelectCountFilteredTransUnit.sql", mimeType="application/octet-stream")]
	private static const SelectCountFilteredTransUnitClass:Class;
	private static const SELECT_COUNT_FILTERED_TRANS_UNIT_SQL:String = new SelectCountFilteredTransUnitClass();
	public function get selectCountFilteredTransUnit():String {
		return SELECT_COUNT_FILTERED_TRANS_UNIT_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/SelectTransUnit.sql", mimeType="application/octet-stream")]
	private static const SelectTransUnitClass:Class;
	private static const SELECT_TRANS_UNIT_SQL:String = new SelectTransUnitClass();
	public function get selectTransUnit():String {
		return SELECT_TRANS_UNIT_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/SelectFilteredTransUnit.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredTransUnitClass:Class;
	private static const SELECT_FILTERED_TRANS_UNIT_SQL:String = new SelectFilteredTransUnitClass();
	public function get selectFilteredTransUnit():String {
		return SELECT_FILTERED_TRANS_UNIT_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/SelectTheme.sql", mimeType="application/octet-stream")]
	private static const SelectThemeClass:Class;
	private static const SELECT_THEME_SQL:String = new SelectThemeClass();
	public function get selectTheme():String {
		return SELECT_THEME_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/SelectFilter.sql", mimeType="application/octet-stream")]
	private static const SelectFilterClass:Class;
	private static const SELECT_FILTER_SQL:String = new SelectFilterClass();
	public function get selectFilter():String {
		return SELECT_FILTER_SQL;
	}

	//--------------------------------------
	//  delete
	//--------------------------------------

	[Embed(source="/dittner/testmyself/command/backend/sql/DeleteTransUnit.sql", mimeType="application/octet-stream")]
	private static const DeleteTransUnitClass:Class;
	private static const DELETE_TRANS_UNIT_SQL:String = new DeleteTransUnitClass();
	public function get deleteTransUnit():String {
		return DELETE_TRANS_UNIT_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/DeleteTheme.sql", mimeType="application/octet-stream")]
	private static const DeleteThemeClass:Class;
	private static const DELETE_THEME_SQL:String = new DeleteThemeClass();
	public function get deleteTheme():String {
		return DELETE_THEME_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/DeleteFilterByID.sql", mimeType="application/octet-stream")]
	private static const DeleteFilterByIDClass:Class;
	private static const DELETE_FILTER_BY_ID_SQL:String = new DeleteFilterByIDClass();
	public function get deleteFilterByID():String {
		return DELETE_FILTER_BY_ID_SQL;
	}

	[Embed(source="/dittner/testmyself/command/backend/sql/DeleteFilterByTransUnitID.sql", mimeType="application/octet-stream")]
	private static const DeleteFilterByTransUnitIDClass:Class;
	private static const DELETE_FILTER_BY_TRANS_UNIT_ID_SQL:String = new DeleteFilterByTransUnitIDClass();
	public function get deleteFilterByTransUnitID():String {
		return DELETE_FILTER_BY_TRANS_UNIT_ID_SQL;
	}

}
}
