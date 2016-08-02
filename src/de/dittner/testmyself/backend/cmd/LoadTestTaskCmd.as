package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.SelectNoteForTestTaskOperation;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTask;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class LoadTestTaskCmd extends StorageOperation implements IAsyncCommand {

	public function LoadTestTaskCmd(storage:Storage, test:Test, taskID:int) {
		super();
		this.storage = storage;
		this.test = test;
		this.taskID = taskID;
	}

	private var storage:Storage;
	private var test:Test;
	private var taskID:int;
	private var task:TestTask;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.taskID = taskID;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_TEST_TASK_BY_ID_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array)
			for each(var item:Object in result.data) {
				task = test.createTestTask();
				task.deserialize(item);
				break;
			}

		if (task) {
			var loadNoteCmd:IAsyncCommand = new SelectNoteForTestTaskOperation(storage, task);
			loadNoteCmd.addCompleteCallback(taskParsingCompleteHandler);
			loadNoteCmd.execute();
		}
		else {
			dispatchError("Не удалось загрузить тестовую задачу!");
		}
	}

	private function taskParsingCompleteHandler(op:IAsyncOperation):void {
		if (op.isSuccess && task.note)
			dispatchSuccess(task);
		else
			dispatchError("Не удалось загрузить запись для теста!");
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
		test = null;
	}
}
}