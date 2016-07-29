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

public class DeleteThemeOperation extends StorageOperation implements IAsyncCommand {

	public function DeleteThemeOperation(storage:Storage, theme:Theme) {
		super();
		this.storage = storage;
		this.theme = theme;
	}

	private var storage:Storage;
	private var theme:Theme;

	public function execute():void {
		if (theme.id == -1) {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": Отсутствует ID темы");
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_THEME_SQL, {deletingThemeID: theme.id});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(deleteCompleteHandler, executeError));
		}
	}

	private function deleteCompleteHandler(result:SQLResult):void {
		theme.vocabulary.removeTheme(theme);
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}