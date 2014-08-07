package dittner.testmyself.command.sql.common {

import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.model.model_internal;
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.command.core.operation.PhaseOperation;
import dittner.testmyself.command.core.operation.SQLErrorCode;

import flash.data.SQLResult;
import flash.errors.SQLError;

use namespace model_internal;

public class ThemeInsertTransactionSubPhase extends PhaseOperation {
	public function ThemeInsertTransactionSubPhase(theme:Theme, sqlRunner:SQLRunner, sqlStatement:String) {
		this.theme = theme;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
	}

	private var theme:Theme;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;

	override public function execute():void {
		var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
		var sqlParams:Object = {};
		sqlParams.name = theme.name;
		statements.push(new QueuedStatement(sqlStatement, sqlParams));
		sqlRunner.executeModify(statements, executeComplete, executeError);

	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		var result:SQLResult = results[0];
		if (result.rowsAffected > 0) {
			theme._id = result.lastInsertRowID;
			completeSuccess();
		}
		else completeWithError(SQLErrorCode.THEME_ADDED_WITHOUT_ID);
	}

	private function executeError(error:SQLError):void {
		completeWithError(error.toString());
	}

	override protected function destroy():void {
		super.destroy();
		theme = null;
		sqlRunner = null;
		sqlStatement = null;
	}
}
}