package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class UpdateFilterOperation extends StorageOperation implements IAsyncCommand {

	public function UpdateFilterOperation(storage:Storage, newTheme:Theme, oldTheme:Theme) {
		super();
		this.storage = storage;
		this.newTheme = newTheme;
		this.oldTheme = oldTheme;
	}

	private var storage:Storage;
	private var newTheme:Theme;
	private var oldTheme:Theme;

	public function execute():void {
		if (newTheme.id == -1 || oldTheme.id == -1) {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": Отсутствует ID темы");
		}
		else {
			var sqlParams:Object = {};
			sqlParams.newThemeID = newTheme.id;
			sqlParams.oldThemeID = oldTheme.id;

			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.UPDATE_FILTER_SQL, sqlParams);
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}