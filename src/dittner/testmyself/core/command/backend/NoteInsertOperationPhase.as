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

public class NoteInsertOperationPhase extends PhaseOperation {

	public function NoteInsertOperationPhase(sqlRunner:SQLRunner, note:Note, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.note = note;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var note:Note;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		var sqlParams:Object = note.toSQLData();
		sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(sqlFactory.insertNote, sqlParams)]), executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		var result:SQLResult = results[0];
		if (result.rowsAffected > 0) {
			note.id = result.lastInsertRowID;
			dispatchComplete();
		}
		else {
			throw new CommandException(ErrorCode.NOTE_ADDED_WITHOUT_ID, "База данных не вернула ID после добавления единицы перевода");
		}
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
