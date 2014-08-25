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

public class TransUnitInsertTransactionPhase extends PhaseOperation {

	public function TransUnitInsertTransactionPhase(sqlRunner:SQLRunner, unit:TransUnit, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.unit = unit;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var unit:TransUnit;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		var sqlParams:Object = unit.toHash();
		sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(sqlFactory.insertTransUnit, sqlParams)]), executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		var result:SQLResult = results[0];
		if (result.rowsAffected > 0) {
			unit.id = result.lastInsertRowID;
			dispatchComplete();
		}
		else {
			throw new CommandException(ErrorCode.TRANS_UNIT_ADDED_WITHOUT_ID, "База данных не вернула ID после добавления единицы перевода");
		}
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
