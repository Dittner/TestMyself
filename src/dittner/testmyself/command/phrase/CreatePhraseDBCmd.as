package dittner.testmyself.command.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.DeferredCommand;
import dittner.testmyself.model.AppConfig;
import dittner.testmyself.service.phrase.PhraseService;

import flash.data.SQLResult;
import flash.errors.SQLError;
import flash.filesystem.File;

public class CreatePhraseDBCmd extends DeferredCommand {

	[Embed(source="/dittner/testmyself/service/phrase/sql/CreatePhraseDBStatement.sql", mimeType="application/octet-stream")]
	private static const CreatePhraseTableClass:Class;
	private static const CREATE_PHRASE_TABLE:String = new CreatePhraseTableClass();

	[Inject]
	public var service:PhraseService;

	override public function process():void {
		if (service.isDataBaseCreated) dispatchComplete();
		else createDB();
	}

	private function createDB():void {
		var dbRootFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath);
		if (!dbRootFile.exists) dbRootFile.createDirectory();

		var dbFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + AppConfig.PHRASE_DB_NAME);
		service.sqlRunner = new SQLRunner(dbFile);

		if (!dbFile.exists) {
			var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			statements[statements.length] = new QueuedStatement(CREATE_PHRASE_TABLE);
			//statements[statements.length] = new QueuedStatement(CREATE_THEME_TABLE);

			service.sqlRunner.executeModify(statements, executeComplete, executeError, null);
		}
		else dispatchComplete();
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		dispatchError(error.toString());
	}

}
}
