package dittner.testmyself.core.command.backend {

import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.theme.Theme;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class ThemeInsertOperationSubPhase extends PhaseOperation {
	public function ThemeInsertOperationSubPhase(theme:Theme, sqlRunner:SQLRunner, sqlStatement:String) {
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
			theme.id = result.lastInsertRowID;
			dispatchComplete();
		}
		else throw new CommandException(ErrorCode.THEME_ADDED_WITHOUT_ID, "База данных не вернула ID добавленной темы");
	}

	private function executeError(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details);
	}

	override public function destroy():void {
		super.destroy();
		theme = null;
		sqlRunner = null;
		sqlStatement = null;
	}
}
}