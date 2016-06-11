package dittner.testmyself.core.command.backend {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class FilteredNoteCountOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function FilteredNoteCountOperationPhase(conn:SQLConnection, info:NotesInfo, filter:NoteFilter, sqlFactory:SQLFactory) {
		this.conn = conn;
		this.info = info;
		this.filter = filter;
		this.sqlFactory = sqlFactory;
	}

	private var info:NotesInfo;
	private var conn:SQLConnection;
	private var filter:NoteFilter;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.searchFilter = filter.searchFullIdentity ? filter.searchText : "%" + filter.searchText + "%";

		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			var sql:String = sqlFactory.selectCountFilteredNote;
			sql = sql.replace("#filterList", themes);
		}
		else {
			sql = sqlFactory.selectCountNote;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				info.filteredNotesAmount = countData[prop] as int;
				break;
			}
			dispatchSuccess();
		}
		else {
			dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число записей в таблице"));
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		conn = null;
	}
}
}
