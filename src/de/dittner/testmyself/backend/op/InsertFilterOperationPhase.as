package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class InsertFilterOperationPhase extends StorageOperation implements IAsyncCommand {
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

	override public function destroy():void {
		super.destroy();
		theme = null;
		storage = null;
		note = null;
	}
}
}