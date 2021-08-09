package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.ui.common.page.TestPage;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class LoadTaskIDsCmd extends StorageOperation implements IAsyncCommand {
	public function LoadTaskIDsCmd(storage:Storage, page:TestPage) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:TestPage;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.testID = page.test.id;
		sqlParams.complexity = page.taskComplexity;

		var sql:String;
		if (page.selectedTag) {
			sqlParams.selectedTagID = "%" + Tag.DELIMITER + page.selectedTag.id + Tag.DELIMITER + "%";
			sql = page.test.useExamples ? SQLLib.SELECT_FILTERED_TEST_TASK_IDS_FOR_EXAMPLES_SQL : SQLLib.SELECT_FILTERED_TEST_TASK_IDS_SQL;
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
		page = null;
	}
}
}