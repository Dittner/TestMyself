package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectExamplesSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectExamplesSQLOperation(service:SQLStorage, note:Note) {
		super();
		this.service = service;
		this.note = note;
	}

	private var service:SQLStorage;
	private var note:Note;

	public function execute():void {
		if (!note || note.id == -1) {
			CLog.err(LogCategory.STORAGE, ErrorCode.NULLABLE_NOTE + ": Отсутствует запись или ID записи");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_EXAMPLE_BY_PARENT_ID_SQL, {parentID: note.id});
			statement.sqlConnection = service.sqlConnection;
			statement.execute(-1, new Responder(executeComplete));
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
}
}