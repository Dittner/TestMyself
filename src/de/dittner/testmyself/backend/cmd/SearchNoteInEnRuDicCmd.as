package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SearchNoteInEnRuDicCmd extends StorageOperation implements IAsyncCommand {

	public function SearchNoteInEnRuDicCmd(storage:Storage, noteTitle:String) {
		super();
		this.storage = storage;
		this.noteTitle = noteTitle;
	}

	private var storage:Storage;
	private var noteTitle:String;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.title = noteTitle;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_EN_RU_DIC_NOTE_SQL, sqlParams);
		statement.sqlConnection = storage.enRuDicSqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array && (result.data as Array).length > 0) {
			dispatchSuccess(result.data[0]);
		}
		else {
			dispatchSuccess(null);
		}
	}
}
}