package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.Device;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;
import flash.filesystem.File;

public class RunDataBaseCmd extends StorageOperation implements IAsyncCommand {

	public function RunDataBaseCmd(createTableStatements:Array) {
		super();
		this.createTableStatements = createTableStatements;
	}

	private var createTableStatements:Array;
	private var conn:SQLConnection = new SQLConnection();

	public function execute():void {
		var dbRootFile:File = File.documentsDirectory.resolvePath(Device.dbRootPath);
		if (!dbRootFile.exists) dbRootFile.createDirectory();
		var dbFile:File = File.documentsDirectory.resolvePath(Device.dbPath);

		conn.addEventListener(SQLEvent.OPEN, openHandler);
		conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
		conn.openAsync(dbFile);
	}

	private function openHandler(event:SQLEvent):void {
		createTables();
	}

	private function createTables():void {
		var createStmt:SQLStatement;

		for (var i:int = 0; i < createTableStatements.length; i++) {
			var statement:String = createTableStatements[i];
			createStmt = new SQLStatement();
			createStmt.sqlConnection = conn;
			createStmt.text = statement;
			if (i == createTableStatements.length - 1) {
				createStmt.addEventListener(SQLEvent.RESULT, createResult);
				createStmt.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			}
			createStmt.execute();
		}
	}

	private function createResult(event:SQLEvent):void {
		CLog.info(LogCategory.STORAGE, "SQL DB " + Device.APP_NAME + " has been created and launched");
		dispatchSuccess(conn);
	}

	private function errorHandler(event:SQLErrorEvent):void {
		dispatchError(error.toString());
	}

}
}
