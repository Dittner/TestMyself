package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.Device;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;
import flash.filesystem.File;
import flash.net.Responder;

public class CreateDataBaseSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function CreateDataBaseSQLOperation(service:SQLStorage, spec:NoteServiceSpec) {
		super();
		this.service = service;
		this.spec = spec;
	}

	private var service:SQLStorage;
	private var spec:NoteServiceSpec;

	public function execute():void {
		var dbRootFile:File = File.documentsDirectory.resolvePath(Device.dbRootPath);
		if (!dbRootFile.exists) {
			var appDBDir:File = File.applicationDirectory.resolvePath(Device.applicationDBPath);
			if (appDBDir.exists) {
				var destDir:File = File.documentsDirectory.resolvePath(Device.APP_NAME);
				appDBDir.copyTo(destDir);
			}
			else {
				dbRootFile.createDirectory();
			}
		}

		var dbFile:File = File.documentsDirectory.resolvePath(Device.dbRootPath + spec.dbName + ".db");

		if (!dbFile.exists) {
			var statements:Array = [];
			statements.push(service.sqlFactory.createNoteTbl);
			statements.push(service.sqlFactory.createFilterTbl);
			statements.push(service.sqlFactory.createThemeTbl);
			statements.push(service.sqlFactory.createExampleTbl);
			statements.push(service.sqlFactory.createTestTbl);
			statements.push(service.sqlFactory.createTestExampleTbl);

			service.sqlConnection.open(dbFile);
			createTables(statements);
			service.sqlConnection.close();
		}

		service.sqlConnection.addEventListener(SQLErrorEvent.ERROR, openFailedHandler);
		service.sqlConnection.addEventListener(SQLEvent.OPEN, openSuccessHandler);
		service.sqlConnection.openAsync(dbFile);
	}

	private function createTables(statements:Array):void {
		var createStmt:SQLStatement;

		for (var i:int = 0; i < statements.length; i++) {
			var statement:String = statements[i];
			createStmt = new SQLStatement();
			createStmt.sqlConnection = service.sqlConnection;
			createStmt.text = statement;
			if (i == statements.length - 1) createStmt.execute(-1, new Responder(executeComplete, executeError));
			else createStmt.execute();
		}
	}

	private function openSuccessHandler(event:SQLEvent):void {
		dispatchSuccess();
	}

	private function openFailedHandler(event:SQLErrorEvent):void {
		var errDetails:String = error.toString();
		dispatchError(errDetails);
	}

	private function executeComplete(result:SQLResult):void {}

	private function executeError(error:SQLError):void {
		dispatchError(error);
	}

}
}
