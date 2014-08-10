package dittner.testmyself.command.backend.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.exception.CommandException;
import dittner.testmyself.command.core.deferredOperation.DeferredOperation;
import dittner.testmyself.command.core.deferredOperation.ErrorCode;
import dittner.testmyself.model.AppConfig;
import dittner.testmyself.service.PhraseService;

import flash.data.SQLResult;
import flash.errors.SQLError;
import flash.filesystem.File;

public class CreatePhraseDataBaseSQLOperation extends DeferredOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/CreatePhraseTbl.sql", mimeType="application/octet-stream")]
	private static const CreatePhraseTblClass:Class;
	private static const CREATE_PHRASE_TBL_SQL:String = new CreatePhraseTblClass();

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/CreateThematicPhraseTbl.sql", mimeType="application/octet-stream")]
	private static const CreateThematicPhraseTblClass:Class;
	private static const CREATE_THEMATIC_PHRASE_TBL_SQL:String = new CreateThematicPhraseTblClass();

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/CreatePhraseThemeTbl.sql", mimeType="application/octet-stream")]
	private static const CreatePhraseThemeTblClass:Class;
	private static const CREATE_PHRASE_THEME_TBL_SQL:String = new CreatePhraseThemeTblClass();

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function CreatePhraseDataBaseSQLOperation(service:PhraseService) {
		super();
		this.service = service;
	}

	private var service:PhraseService;

	override public function process():void {

		var dbRootFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath);
		if (!dbRootFile.exists) dbRootFile.createDirectory();

		var dbFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + AppConfig.PHRASE_DB_NAME);
		service.sqlRunner = new SQLRunner(dbFile);

		if (!dbFile.exists) {
			var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			statements.push(new QueuedStatement(CREATE_PHRASE_TBL_SQL));
			statements.push(new QueuedStatement(CREATE_THEMATIC_PHRASE_TBL_SQL));
			statements.push(new QueuedStatement(CREATE_PHRASE_THEME_TBL_SQL));

			service.sqlRunner.executeModify(statements, executeComplete, executeError, null);
		}
		else dispatchCompleteSuccess();
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchCompleteSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchCompleteSuccess();
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Ошибка при создании БД: " + error.toString());
	}

}
}
