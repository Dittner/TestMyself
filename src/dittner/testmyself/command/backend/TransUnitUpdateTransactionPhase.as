package dittner.testmyself.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.common.TransUnit;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class TransUnitUpdateTransactionPhase extends PhaseOperation {

	public function TransUnitUpdateTransactionPhase(sqlRunner:SQLRunner, unit:TransUnit, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.unit = unit;
		this.sqlFactory = sqlFactory;
	}

	private var unit:TransUnit;
	private var sqlFactory:SQLFactory;
	private var sqlRunner:SQLRunner;

	override public function execute():void {
		var sqlParams:Object = unit.toHash();
		sqlParams.updatingTransUnitID = unit.id;
		sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(sqlFactory.updateTransUnit, sqlParams)]), executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details);
	}

	override public function destroy():void {
		super.destroy();
		unit = null;
		sqlRunner = null;
	}
}
}
