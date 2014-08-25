package dittner.testmyself.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.utils.SQLFactory;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class DeleteTransUnitTransactionPhase extends PhaseOperation {

	public function DeleteTransUnitTransactionPhase(sqlRunner:SQLRunner, transUnitID:int, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.transUnitID = transUnitID;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var transUnitID:int;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		if (transUnitID) {
			var statements:Vector.<QueuedStatement> = new <QueuedStatement>[];
			statements.push(new QueuedStatement(sqlFactory.deleteTransUnit, {deletingTransUnitID: transUnitID}));
			sqlRunner.executeModify(statements, deleteCompleteHandler, deleteFailedHandler);
		}
		else throw new CommandException(ErrorCode.NULL_TRANS_UNIT, "Отсутствует ID фразы");
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