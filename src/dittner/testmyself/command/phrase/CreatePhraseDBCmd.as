package dittner.testmyself.command.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.model.AppConfig;
import dittner.testmyself.command.core.deferredComandManager.DeferredCommand;
import dittner.testmyself.service.PhraseService;

import flash.data.SQLResult;
import flash.errors.SQLError;
import flash.filesystem.File;

public class CreatePhraseDBCmd extends DeferredCommand {

	[Embed(source="/dittner/testmyself/command/sql/phrase/statement/CreatePhraseTbl.sql", mimeType="application/octet-stream")]
	private static const CreatePhraseTblClass:Class;
	private static const CREATE_PHRASE_TBL_SQL:String = new CreatePhraseTblClass();

	[Embed(source="/dittner/testmyself/command/sql/phrase/statement/CreateThematicPhraseTbl.sql", mimeType="application/octet-stream")]
	private static const CreateThematicPhraseTblClass:Class;
	private static const CREATE_THEMATIC_PHRASE_TBL_SQL:String = new CreateThematicPhraseTblClass();

	[Embed(source="/dittner/testmyself/command/sql/phrase/statement/CreatePhraseThemeTbl.sql", mimeType="application/octet-stream")]
	private static const CreatePhraseThemeTblClass:Class;
	private static const CREATE_PHRASE_THEME_TBL_SQL:String = new CreatePhraseThemeTblClass();

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
			statements.push(new QueuedStatement(CREATE_PHRASE_TBL_SQL));
			statements.push(new QueuedStatement(CREATE_THEMATIC_PHRASE_TBL_SQL));
			statements.push(new QueuedStatement(CREATE_PHRASE_THEME_TBL_SQL));

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
