package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.IAsyncCommand;
import dittner.testmyself.core.command.backend.utils.SQLUtils;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class DropColumnSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function DropColumnSQLOperation(conn:SQLConnection, tableName:String, deletingColumnNameHash:Object, createTblSql:String, insertItemSql:String) {
		super();
		this.conn = conn;
		this.tableName = tableName;
		this.deletingColumnNameHash = deletingColumnNameHash;
		this.createTblSql = createTblSql;
		this.insertItemSql = insertItemSql;
	}

	private var conn:SQLConnection;
	private var tableName:String;
	private var deletingColumnNameHash:Object;
	private var createTblSql:String;
	private var insertItemSql:String;

	public function execute():void {
		readAllTest();
	}

	private function readAllTest():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement("SELECT * FROM " + tableName);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(readAllTestComplete));
	}

	private var updatedItems:Array = [];
	private function readAllTestComplete(result:SQLResult):void {
		var items:Array = result.data is Array ? result.data as Array : [];
		var updatedItem:Object;
		for each(var item:Object in items) {
			updatedItem = {};
			for (var prop:String in item)
				if (!deletingColumnNameHash[prop]) updatedItem[prop] = item[prop];
			updatedItem["rate"] = calcTaskRate();
			updatedItems.push(updatedItem);
		}
		if (updatedItems.length == 0) dispatchSuccess();
		removeTbl();
	}

	private static const MSEC_IN_DAY:Number = 24 * 60 * 60 * 1000;
	public function calcTaskRate():Number {
		return (new Date).time + Math.round(Math.random() * MSEC_IN_DAY) - MSEC_IN_DAY / 2;
	}

	/*delete table*/
	private function removeTbl():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement("DROP TABLE IF EXISTS " + tableName);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(removeTblComplete, removeTblError));
	}

	private function removeTblComplete(result:SQLResult):void {
		createTbl();
	}

	private function removeTblError(error:SQLError):void {
		trace(error.toString());
	}

	/*create table*/
	private function createTbl():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(createTblSql);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(createTblComplete, createTblError));
	}

	private function createTblComplete(result:SQLResult):void {
		addItems();
	}

	private function createTblError(error:SQLError):void {
		trace(error.toString());
	}

	/*add updated items*/
	private var total:int = 0;
	public function addItems():void {
		total = updatedItems.length;
		for each(var item:Object in updatedItems) {
			var insertStmt:SQLStatement = SQLUtils.createSQLStatement(insertItemSql, item);
			insertStmt.sqlConnection = conn;
			insertStmt.execute(-1, new Responder(resultHandler, errorHandler));
		}
	}

	private function resultHandler(result:SQLResult):void {
		total--;
		if (total == 0)
			dispatchSuccess();
	}

	private function errorHandler(error:SQLError):void {
		var errDetails:String = error.toString();
	}
}
}