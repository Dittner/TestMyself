package dittner.testmyself.deutsch.model.domain.verb {
import dittner.testmyself.core.model.note.SQLFactory;

public class VerbSQLFactory extends SQLFactory {
	public function VerbSQLFactory() {}

	[Embed(source="/dittner/testmyself/deutsch/command/backend/CreateVerbTbl.sql", mimeType="application/octet-stream")]
	private static const CreateVerbTblClass:Class;
	private static const CREATE_VERB_TBL_SQL:String = new CreateVerbTblClass();
	override public function get createNoteTbl():String {
		return CREATE_VERB_TBL_SQL;
	}

	[Embed(source="/dittner/testmyself/deutsch/command/backend/InsertVerb.sql", mimeType="application/octet-stream")]
	private static const InsertVerbClass:Class;
	private static const INSERT_VERB_SQL:String = new InsertVerbClass();
	override public function get insertNote():String {
		return INSERT_VERB_SQL;
	}

	[Embed(source="/dittner/testmyself/deutsch/command/backend/UpdateVerb.sql", mimeType="application/octet-stream")]
	private static const UpdateVerbClass:Class;
	private static const UPDATE_VERB_SQL:String = new UpdateVerbClass();
	override public function get updateNote():String {
		return UPDATE_VERB_SQL;
	}

	[Embed(source="/dittner/testmyself/deutsch/command/backend/SelectVerbKeys.sql", mimeType="application/octet-stream")]
	private static const SelectVerbKeysClass:Class;
	private static const SELECT_VERB_KEYS_SQL:String = new SelectVerbKeysClass();
	override public function get selectNoteKeys():String {
		return SELECT_VERB_KEYS_SQL;
	}
}
}
