package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncCommand;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;

import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;
import flash.filesystem.File;

public class RunDataBaseCmd extends AsyncCommand {

	private static const APP_NAME:String = "TestMyself";

	public function RunDataBaseCmd(dbName:String, createTableStatements:Array) {
		super();
		this.dbName = dbName;
		this.createTableStatements = createTableStatements;
	}

	private var dbName:String;
	private var createTableStatements:Array;
	private var conn:SQLConnection = new SQLConnection();

	private function get dbRootPath():String {
		return APP_NAME + File.separator;
	}

	override public function execute():void {
		var dbRootFile:File = File.applicationStorageDirectory.resolvePath(dbRootPath);
		if (!dbRootFile.exists) dbRootFile.createDirectory();
		var dbFile:File = File.applicationStorageDirectory.resolvePath(dbRootPath + dbName + ".db");

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
		CLog.info(LogCategory.STORAGE, "SQL DB " + dbName + " has been created and launched");
		dispatchSuccess(conn);
	}

	private function errorHandler(event:SQLErrorEvent):void {
		var errDetails:String = error.toString();
		CLog.err(LogCategory.STORAGE, "SQL DB " + dbName + " open is failed, details: " + errDetails);
		dispatchError(errDetails);
	}

}
}
