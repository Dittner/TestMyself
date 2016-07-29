package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class UpdateNoteOperation extends StorageOperation implements IAsyncCommand {

	public function UpdateNoteOperation(storage:Storage, note:Note) {
		this.storage = storage;
		this.note = note;
	}

	private var note:Note;
	private var storage:Storage;

	public function execute():void {
		var sqlParams:Object = note.serialize();
		sqlParams.updatingNoteID = note.id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.UPDATE_NOTE_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		note = null;
		storage = null;
	}
}
}
