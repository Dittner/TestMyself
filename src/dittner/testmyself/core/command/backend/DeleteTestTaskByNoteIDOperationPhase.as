package dittner.testmyself.core.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class DeleteTestTaskByNoteIDOperationPhase extends PhaseOperation {

	public function DeleteTestTaskByNoteIDOperationPhase(sqlRunner:SQLRunner, noteID:int, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.noteID = noteID;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var noteID:int;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		if (noteID != -1) {
			var statements:Vector.<QueuedStatement> = new <QueuedStatement>[];
			statements.push(new QueuedStatement(sqlFactory.deleteTestTaskByNoteID, {deletingNoteID: noteID}));
			sqlRunner.executeModify(statements, deleteCompleteHandler, deleteFailedHandler);
		}
		else throw new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID записи");
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