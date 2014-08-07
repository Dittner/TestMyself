package dittner.testmyself.command.sql.common {

import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.model.common.TransUnit;
import dittner.testmyself.model.model_internal;
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.command.core.operation.PhaseOperation;

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
		completeSuccess();
	}

	private function executeError(error:SQLError):void {
		completeWithError(error.toString());
	}

	override protected function destroy():void {
		super.destroy();
		transUnit = null;
		theme = null;
		sqlRunner = null;
		sqlStatement = null;
	}
}
}