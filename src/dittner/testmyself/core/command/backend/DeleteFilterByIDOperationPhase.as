package dittner.testmyself.core.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.utils.SQLFactory;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class DeleteFilterByIDOperationPhase extends PhaseOperation {

	public function DeleteFilterByIDOperationPhase(sqlRunner:SQLRunner, themeID:int, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.themeID = themeID;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var themeID:int;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		if (themeID) {
			var statements:Vector.<QueuedStatement> = new <QueuedStatement>[];
			statements.push(new QueuedStatement(sqlFactory.deleteFilterByID, {deletingThemeID: themeID}));
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