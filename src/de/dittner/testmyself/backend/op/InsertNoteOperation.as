package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class InsertNoteOperation extends StorageOperation implements IAsyncCommand {

	public function InsertNoteOperation(storage:Storage, note:Note) {
		this.storage = storage;
		this.note = note;
	}

	private var storage:Storage;
	private var note:Note;

	public function execute():void {
		var sqlParams:Object = note.serialize();
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.INSERT_NOTE_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			if (note.isNew) note.id = result.lastInsertRowID;
			dispatchSuccess();
		}
		else {
			dispatchError(ErrorCode.NOTE_ADDED_WITHOUT_ID + ": База данных не вернула ID после добавления записи");
		}
	}

	override public function destroy():void {
		super.destroy();
		note = null;
		storage = null;
	}
}
}
