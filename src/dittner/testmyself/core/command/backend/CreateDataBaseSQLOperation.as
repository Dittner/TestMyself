package dittner.testmyself.core.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;

import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.core.service.NoteServiceSpec;
import dittner.testmyself.deutsch.model.AppConfig;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;
import flash.filesystem.File;
import flash.net.Responder;

public class CreateDataBaseSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function CreateDataBaseSQLOperation(service:NoteService, spec:NoteServiceSpec) {
		super();
		this.service = service;
		this.spec = spec;
	}

	private var service:NoteService;
	private var spec:NoteServiceSpec;

	public function execute():void {
		var dbRootFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath);
		if (!dbRootFile.exists) {
			var appDBDir:File = File.applicationDirectory.resolvePath(AppConfig.applicationDBPath);
			if (appDBDir.exists) {
				var destDir:File = File.documentsDirectory.resolvePath(AppConfig.APP_NAME);
				appDBDir.copyTo(destDir);
			}
			else {
				dbRootFile.createDirectory();
			}
		}

		var dbFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + spec.dbName + ".db");

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
