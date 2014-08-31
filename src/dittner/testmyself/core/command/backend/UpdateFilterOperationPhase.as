package dittner.testmyself.core.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.utils.SQLFactory;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class UpdateFilterOperationPhase extends PhaseOperation {

	public function UpdateFilterOperationPhase(sqlRunner:SQLRunner, newThemeID:int, oldThemeID:int, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.newThemeID = newThemeID;
		this.oldThemeID = oldThemeID;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var newThemeID:int;
	private var oldThemeID:int;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		if (newThemeID && oldThemeID) {
			var sqlParams:Object = {};
			sqlParams.newThemeID = newThemeID;
			sqlParams.oldThemeID = oldThemeID;

			var statements:Vector.<QueuedStatement> = new <QueuedStatement>[];
			statements.push(new QueuedStatement(sqlFactory.updateFilter, sqlParams));
			sqlRunner.executeModify(statements, deleteCompleteHandler, deleteFailedHandler);
		}
		else throw new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID темы");
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