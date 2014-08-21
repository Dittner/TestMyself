package dittner.testmyself.command.backend.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.result.CommandException;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class DeletePhraseThemeTransactionPhase extends PhaseOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/DeletePhraseTheme.sql", mimeType="application/octet-stream")]
	private static const DeletePhraseSQLClass:Class;
	private static const DELETE_PHRASE_SQL:String = new DeletePhraseSQLClass();

	public function DeletePhraseThemeTransactionPhase(sqlRunner:SQLRunner, themeID:int) {
		super();
		this.sqlRunner = sqlRunner;
		this.themeID = themeID;
	}

	private var sqlRunner:SQLRunner;
	private var themeID:int;

	override public function execute():void {
		if (themeID) {
			var statements:Vector.<QueuedStatement> = new <QueuedStatement>[];
			statements.push(new QueuedStatement(DELETE_PHRASE_SQL, {deletingThemeID: themeID}));
			sqlRunner.executeModify(statements, deleteCompleteHandler, deleteFailedHandler);
		}
		else throw new CommandException(ErrorCode.NULL_TRANS_UNIT, "Отсутствует ID темы");
	}

	private function deleteCompleteHandler(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function deleteFailedHandler(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details);
	}

	override public function destroy():void {
		super.destroy();
		sqlRunner = null;
	}
}
}