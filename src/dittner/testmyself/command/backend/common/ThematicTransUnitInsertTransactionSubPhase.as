package dittner.testmyself.command.backend.common {

import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.exception.CommandException;

import dittner.testmyself.command.core.deferredOperation.ErrorCode;

import dittner.testmyself.model.common.TransUnit;
import dittner.testmyself.model.model_internal;
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.command.core.phaseOperation.PhaseOperation;

import flash.data.SQLResult;
import flash.errors.SQLError;

use namespace model_internal;

public class ThematicTransUnitInsertTransactionSubPhase extends PhaseOperation {
	public function ThematicTransUnitInsertTransactionSubPhase(transUnit:TransUnit, theme:Theme, sqlRunner:SQLRunner, sqlStatement:String) {
		this.transUnit = transUnit;
		this.theme = theme;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
	}

	private var transUnit:TransUnit;
	private var theme:Theme;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;

	override public function execute():void {
		var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
		var sqlParams:Object = {};
		sqlParams.transUnitID = transUnit.id;
		sqlParams.themeID = theme.id;

		statements.push(new QueuedStatement(sqlStatement, sqlParams));
		sqlRunner.executeModify(statements, executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details);
	}

	override public function destroy():void {
		super.destroy();
		transUnit = null;
		theme = null;
		sqlRunner = null;
		sqlStatement = null;
	}
}
}