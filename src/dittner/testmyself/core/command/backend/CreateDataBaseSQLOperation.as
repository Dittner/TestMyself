package dittner.testmyself.core.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.core.service.NoteServiceSpec;
import dittner.testmyself.deutsch.model.AppConfig;

import flash.data.SQLResult;
import flash.errors.SQLError;
import flash.filesystem.File;

public class CreateDataBaseSQLOperation extends DeferredOperation {

	public function CreateDataBaseSQLOperation(service:NoteService, spec:NoteServiceSpec, sqlFactory:SQLFactory) {
		super();
		this.service = service;
		this.spec = spec;
		this.sqlFactory = sqlFactory;
	}

	private var service:NoteService;
	private var spec:NoteServiceSpec;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var dbRootFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath);
		if (!dbRootFile.exists) dbRootFile.createDirectory();

		var dbFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + spec.dbName + ".db");
		service.sqlRunner = new SQLRunner(dbFile);

		if (!dbFile.exists) {
			var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			statements.push(new QueuedStatement(sqlFactory.createNoteTbl));
			statements.push(new QueuedStatement(sqlFactory.createFilterTbl));
			statements.push(new QueuedStatement(sqlFactory.createThemeTbl));
			statements.push(new QueuedStatement(sqlFactory.createExampleTbl));

			service.sqlRunner.executeModify(statements, executeComplete, executeError, null);
		}
		else dispatchCompleteSuccess(CommandResult.OK);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		if (spec.demoData) spec.demoData.add();
		dispatchCompleteSuccess(CommandResult.OK);
	}

	private function executeError(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Ошибка при создании БД: " + error.toString());
	}

}
}