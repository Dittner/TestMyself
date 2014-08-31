package dittner.testmyself.core.command.backend {

import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.theme.Theme;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class FilterInsertOperationSubPhase extends PhaseOperation {
	public function FilterInsertOperationSubPhase(note:Note, theme:Theme, sqlRunner:SQLRunner, sqlStatement:String) {
		this.note = note;
		this.theme = theme;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
	}

	private var note:Note;
	private var theme:Theme;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;

	override public function execute():void {
		var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
		var sqlParams:Object = {};
		sqlParams.noteID = note.id;
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
		note = null;
		theme = null;
		sqlRunner = null;
		sqlStatement = null;
	}
}
}