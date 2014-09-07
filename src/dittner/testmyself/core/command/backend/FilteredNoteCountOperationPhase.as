package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLResult;

public class FilteredNoteCountOperationPhase extends PhaseOperation {

	public function FilteredNoteCountOperationPhase(sqlRunner:SQLRunner, info:NotesInfo, filter:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.info = info;
		this.filter = filter;
		this.sqlFactory = sqlFactory;
	}

	private var info:NotesInfo;
	private var sqlRunner:SQLRunner;
	private var filter:Array;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		if (filter.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter);
			var statement:String = sqlFactory.selectCountFilteredNote;
			statement = statement.replace("#filterList", themes);
			sqlRunner.execute(statement, null, executeComplete);
		}
		else {
			sqlRunner.execute(sqlFactory.selectCountNote, null, executeComplete);
		}
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				info.filteredNotesAmount = countData[prop] as int;
				break;
			}
			dispatchComplete();
		}
		else {
			throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число записей в таблице");
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		sqlRunner = null;
	}
}
}
