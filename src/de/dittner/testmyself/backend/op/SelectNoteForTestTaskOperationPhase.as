package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.TestTask;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectNoteForTestTaskOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function SelectNoteForTestTaskOperationPhase(storage:SQLStorage, task:TestTask) {
		this.storage = storage;
		this.task = task;
	}

	private var storage:SQLStorage;
	private var task:TestTask;
	private var loadedNote:Note;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.noteID = task.originalData.noteID;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_NOTE_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array)
			for each(var item:Object in result.data) {
				loadedNote = task.test.vocabulary.createNote();
				loadedNote.deserialize(item);
				break;
			}

		if (!loadedNote) {
			CLog.err(LogCategory.STORAGE, "Не удалось загрузить запись в LoadNoteByNoteIDCmd");
			dispatchError();
			return;
		}

		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectExamplesSQLOperation, storage, task.test.vocabulary, loadedNote);
		composite.addOperation(SelectNoteThemesSQLOperation, storage, task.test.vocabulary, loadedNote);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) {
			task.note = loadedNote;
			dispatchSuccess(task);
		}
		else {
			dispatchError(op.error);
		}
	}
}
}