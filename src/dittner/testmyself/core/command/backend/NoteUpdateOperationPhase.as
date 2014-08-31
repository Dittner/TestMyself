package dittner.testmyself.core.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.utils.SQLFactory;
import dittner.testmyself.core.model.note.Note;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class NoteUpdateOperationPhase extends PhaseOperation {

	public function NoteUpdateOperationPhase(sqlRunner:SQLRunner, note:Note, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.note = note;
		this.sqlFactory = sqlFactory;
	}

	private var note:Note;
	private var sqlFactory:SQLFactory;
	private var sqlRunner:SQLRunner;

	override public function execute():void {
		var sqlParams:Object = note.toSQLData();
		sqlParams.updatingNoteID = note.id;
		sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(sqlFactory.updateNote, sqlParams)]), executeComplete, executeError);
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
		sqlRunner = null;
	}
}
}
