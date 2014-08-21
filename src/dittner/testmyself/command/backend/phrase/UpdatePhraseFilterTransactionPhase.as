package dittner.testmyself.command.backend.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.result.CommandException;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class UpdatePhraseFilterTransactionPhase extends PhaseOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/UpdatePhraseFilter.sql", mimeType="application/octet-stream")]
	private static const UpdatePhraseFilterSQLClass:Class;
	private static const UPDATE_PHRASE_FILTER_SQL:String = new UpdatePhraseFilterSQLClass();

	public function UpdatePhraseFilterTransactionPhase(sqlRunner:SQLRunner, newThemeID:int, oldThemeID:int) {
		super();
		this.sqlRunner = sqlRunner;
		this.newThemeID = newThemeID;
		this.oldThemeID = oldThemeID;
	}

	private var sqlRunner:SQLRunner;
	private var newThemeID:int;
	private var oldThemeID:int;

	override public function execute():void {
		if (newThemeID && oldThemeID) {
			var sqlParams:Object = {};
			sqlParams.newThemeID = newThemeID;
			sqlParams.oldThemeID = oldThemeID;

			var statements:Vector.<QueuedStatement> = new <QueuedStatement>[];
			statements.push(new QueuedStatement(UPDATE_PHRASE_FILTER_SQL, sqlParams));
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