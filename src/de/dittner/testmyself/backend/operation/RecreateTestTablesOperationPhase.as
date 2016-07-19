package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.model.domain.note.SQLLib;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class RecreateTestTablesOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function RecreateTestTablesOperationPhase(conn:SQLConnection, sqlFactory:SQLLib) {
		super();
		this.conn = conn;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var sqlFactory:SQLLib;

	public function execute():void {
		var statement:SQLStatement;

		statement = SQLUtils.createSQLStatement("DROP TABLE test");
		statement.sqlConnection = conn;
		statement.execute();

		statement = SQLUtils.createSQLStatement("DROP TABLE testExample");
		statement.sqlConnection = conn;
		statement.execute();

		statement = SQLUtils.createSQLStatement(sqlFactory.createTestTbl);
		statement.sqlConnection = conn;
		statement.execute();

		statement = SQLUtils.createSQLStatement(sqlFactory.createTestExampleTbl);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(error);
	}

	override public function destroy():void {
		super.destroy();
		sqlFactory = null;
		conn = null;
	}
}
}