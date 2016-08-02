package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class LoadTaskIDsCmd extends StorageOperation implements IAsyncCommand {

	public function LoadTaskIDsCmd(storage:Storage, test:Test, filter:Theme, taskComplexity:uint) {
		super();
		this.storage = storage;
		this.test = test;
		this.filter = filter;
		this.taskComplexity = taskComplexity;
	}

	private var storage:Storage;
	private var test:Test;
	private var filter:Theme;
	private var taskComplexity:uint;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.selectedTestID = test.id;
		sqlParams.complexity = taskComplexity;

		var sql:String;
		if (filter) {
			sqlParams.selectedThemeID = filter.id;
			sql = SQLLib.SELECT_FILTERED_TEST_TASK_IDS_SQL;
		}
		else {
			sql = SQLLib.SELECT_TEST_TASK_IDS_SQL;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		var ids:Array = [];
		for each(var item:Object in result.data)
			ids.push(item.id);
		dispatchSuccess(ids);
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
		test = null;
		filter = null;
	}
}
}