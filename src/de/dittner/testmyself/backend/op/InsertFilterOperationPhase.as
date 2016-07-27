package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class InsertFilterOperationPhase extends AsyncOperation implements IAsyncCommand {
	public function InsertFilterOperationPhase(storage:Storage, note:Note, theme:Theme) {
		this.note = note;
		this.theme = theme;
		this.storage = storage;
	}

	private var note:Note;
	private var theme:Theme;
	private var storage:Storage;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.noteID = note.id;
		sqlParams.themeID = theme.id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.INSERT_FILTER_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		theme = null;
		storage = null;
		note = null;
	}
}
}