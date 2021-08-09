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

public class InsertExampleOperationPhase extends StorageOperation implements IAsyncCommand {
	public function InsertExampleOperationPhase(storage:Storage, example:Note) {
		this.example = example;
		this.storage = storage;
	}

	private var example:Note;
	private var storage:Storage;

	public function execute():void {
		if (example.parentID == -1) {
			dispatchError(ErrorCode.PARENT_EXAMPLE_HAS_NO_ID + ": Нет ID записи, необходимого для сохранения примера");
			return;
		}

		var sqlParams:Object = example.serialize();
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.INSERT_NOTE_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			example.id = result.lastInsertRowID;
			var exampleData:Object = example.serialize();
			exampleData.id = example.id;
			if (storage.exampleHash[example.parentID])
				storage.exampleHash[example.parentID].push(exampleData);
			else
				storage.exampleHash[example.parentID] = [exampleData];
			dispatchSuccess();
		}
		else {
			dispatchError(ErrorCode.TAG_ADDED_WITHOUT_ID + ": База данных не вернула ID добавленного примера");
		}
	}

	override public function destroy():void {
		super.destroy();
		example = null;
		storage = null;
	}
}
}