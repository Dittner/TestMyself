package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class SelectExamplesOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectExamplesOperation(storage:Storage, note:Note) {
		super();
		this.storage = storage;
		this.note = note;
	}

	private var storage:Storage;
	private var note:Note;

	public function execute():void {
		if (!note || note.id == -1) {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.NULLABLE_NOTE + ": Отсутствует запись или ID записи");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_EXAMPLE_BY_PARENT_ID_SQL, {parentID: note.id});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
	}

	private function executeComplete(result:SQLResult):void {
		var examples:Array = [];
		var example:Note;
		for each(var item:Object in result.data) {
			example = note.vocabulary.createNote();
			example.deserialize(item);
			examples.push(example);
		}
		note.examples = examples;
		dispatchSuccess(examples);
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}
}
}