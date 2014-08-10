package dittner.testmyself.command.backend.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.exception.CommandException;
import dittner.testmyself.command.core.deferredOperation.DeferredOperation;
import dittner.testmyself.command.core.deferredOperation.ErrorCode;
import dittner.testmyself.model.phrase.IPhrase;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class DeletePhraseSQLOperation extends DeferredOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/DeletePhrase.sql", mimeType="application/octet-stream")]
	private static const DeletePhraseSQLClass:Class;
	private static const DELETE_PHRASE_SQL:String = new DeletePhraseSQLClass();

	public function DeletePhraseSQLOperation(sqlRunner:SQLRunner, phrase:IPhrase) {
		super();
		this.sqlRunner = sqlRunner;
		this.phrase = phrase;
	}

	private var sqlRunner:SQLRunner;
	private var phrase:IPhrase;

	override public function process():void {
		if (phrase && phrase.id) {
			var statements:Vector.<QueuedStatement> = new <QueuedStatement>[];
			statements.push(new QueuedStatement(DELETE_PHRASE_SQL, {deletingPhraseId: phrase.id}));
			sqlRunner.executeModify(statements, deleteCompleteHandler, deleteFailedHandler);

		}
		else dispatchCompletWithError(new CommandException(ErrorCode.NULL_TRANS_UNIT, "Отсутствует удаляемая фраза или не указан id"));
	}

	private function deleteCompleteHandler(results:Vector.<SQLResult>):void {
		dispatchCompleteSuccess(results);
	}

	private function deleteFailedHandler(error:SQLError):void {
		dispatchCompletWithError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}
}
}