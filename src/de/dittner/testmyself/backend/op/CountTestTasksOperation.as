package de.dittner.testmyself.backend.op {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.ui.common.page.TestPage;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class CountTestTasksOperation extends StorageOperation implements IAsyncCommand {

	public function CountTestTasksOperation(storage:Storage, page:TestPage) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:TestPage;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.selectedTestID = page.test.id;
		sqlParams.onlyFailedNotes = page.loadOnlyFailedTestTask ? 1 : 0;

		var sql:String;
		if (page.selectedTag) {
			sqlParams.selectedTagID = "%" + Tag.DELIMITER + page.selectedTag.id + Tag.DELIMITER + "%";

			sql = SQLLib.SELECT_COUNT_FILTERED_TEST_TASK_SQL;
		}
		else {
			sql = SQLLib.SELECT_COUNT_TEST_TASK_SQL;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));

	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				page.allNotesAmount = countData[prop] as int;
				page.countAllNotes = false;
				break;
			}
			dispatchSuccess();
		}
		else {
			dispatchError(ErrorCode.SQL_TRANSACTION_FAILED + ": Не удалось получить число тесовых задач в таблице");
		}
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
		page = null;
	}
}
}