package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectAllNotesTitlesCmd extends StorageOperation implements IAsyncCommand {

	public function SelectAllNotesTitlesCmd(storage:Storage, vocabulary:Vocabulary) {
		super();
		this.storage = storage;
		this.vocabulary = vocabulary;
	}

	private var storage:Storage;
	private var vocabulary:Vocabulary;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_ALL_NOTES_TITLES_SQL, {vocabularyID: vocabulary.id});
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		var titles:Array = result.data is Array ? result.data as Array : [];
		dispatchSuccess(titles);
	}
}
}