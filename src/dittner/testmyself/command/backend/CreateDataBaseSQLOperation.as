package dittner.testmyself.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.AppConfig;
import dittner.testmyself.service.TransUnitService;

import flash.data.SQLResult;
import flash.errors.SQLError;
import flash.filesystem.File;

public class CreateDataBaseSQLOperation extends DeferredOperation {

	public function CreateDataBaseSQLOperation(service:TransUnitService, dbName:String, sqlFactory:SQLFactory) {
		super();
		this.service = service;
		this.dbName = dbName;
		this.sqlFactory = sqlFactory;
	}

	private var service:TransUnitService;
	private var dbName:String;
	private var sqlFactory:SQLFactory;

	override public function process():void {

		var dbRootFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath);
		if (!dbRootFile.exists) dbRootFile.createDirectory();

		var dbFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + dbName + ".db");
		service.sqlRunner = new SQLRunner(dbFile);

		if (!dbFile.exists) {
			var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			statements.push(new QueuedStatement(sqlFactory.createTransUnitTbl));
			statements.push(new QueuedStatement(sqlFactory.createFilterTbl));
			statements.push(new QueuedStatement(sqlFactory.createThemeTbl));

			service.sqlRunner.executeModify(statements, executeComplete, executeError, null);
		}
		else dispatchCompleteSuccess(CommandResult.OK);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchCompleteSuccess(CommandResult.OK);
	}

	private function executeError(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Ошибка при создании БД: " + error.toString());
	}

}
}
