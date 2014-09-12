package dittner.testmyself.deutsch.model.word {
import dittner.testmyself.core.model.note.SQLFactory;

public class WordSQLFactory extends SQLFactory {
	public function WordSQLFactory() {}

	[Embed(source="/dittner/testmyself/deutsch/command/backend/CreateWordTbl.sql", mimeType="application/octet-stream")]
	private static const CreateWordTblClass:Class;
	private static const CREATE_WORD_TBL_SQL:String = new CreateWordTblClass();
	override public function get createNoteTbl():String {
		return CREATE_WORD_TBL_SQL;
	}

	[Embed(source="/dittner/testmyself/deutsch/command/backend/InsertWord.sql", mimeType="application/octet-stream")]
	private static const InsertWordClass:Class;
	private static const INSERT_WORD_SQL:String = new InsertWordClass();
	override public function get insertNote():String {
		return INSERT_WORD_SQL;
	}

	[Embed(source="/dittner/testmyself/deutsch/command/backend/UpdateWord.sql", mimeType="application/octet-stream")]
	private static const UpdateWordClass:Class;
	private static const UPDATE_WORD_SQL:String = new UpdateWordClass();
	override public function get updateNote():String {
		return UPDATE_WORD_SQL;
	}

	[Embed(source="/dittner/testmyself/deutsch/command/backend/SelectWordKeys.sql", mimeType="application/octet-stream")]
	private static const SelectWordKeysClass:Class;
	private static const SELECT_WORD_KEYS_SQL:String = new SelectWordKeysClass();
	override public function get selectNoteKeys():String {
		return SELECT_WORD_KEYS_SQL;
	}
}
}
