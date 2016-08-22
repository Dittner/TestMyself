package de.dittner.testmyself.backend.op {

import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.TestTask;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectNoteForTestTaskOperation extends StorageOperation implements IAsyncCommand {

	public function SelectNoteForTestTaskOperation(storage:Storage, task:TestTask) {
		this.storage = storage;
		this.task = task;
	}

	private var storage:Storage;
	private var task:TestTask;
	private var loadedNote:Note;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.noteID = task.originalData.noteID;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_NOTE_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array)
			for each(var item:Object in result.data) {
				loadedNote = task.test.vocabulary.createNote(item);
				loadedNote.deserialize(item);
				break;
			}

		if (!loadedNote) {
			deleteTestTask(task.id);
			return;
		}

		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectExamplesOperation, storage, loadedNote);
		composite.addOperation(SelectNoteThemesOperation, storage, loadedNote);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function deleteTestTask(taskID:int):void {
		if (taskID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_TEST_TASK_BY_ID_SQL, {id: taskID});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(deleteTestTaskComplete, executeError));
		}
		else {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": Отсутствует ID тестовой задачи");
		}
	}

	private function deleteTestTaskComplete(result:SQLResult):void {
		dispatchError("Не удалось загрузить запись для тестовой задачи, данная задача удалена, попробуйте пеезагрузить тест");
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) {
			task.note = loadedNote;
			dispatchSuccess(task);
		}
		else {
			dispatchError();
		}
	}
}
}