package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class RemoveNotesByThemeCmd extends StorageOperation implements IAsyncCommand {

	public function RemoveNotesByThemeCmd(storage:Storage, theme:Theme) {
		super();
		this.storage = storage;
		this.theme = theme;
	}

	private var storage:Storage;
	private var theme:Theme;

	public function execute():void {
		if (theme.id != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_NOTES_IDS_BY_THEME_SQL, {themeID: theme.id});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(selectIDsCompleteHandler, executeError));
		}
		else {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": Отсутствует тема в БД с id = -1");
		}
	}

	private function selectIDsCompleteHandler(result:SQLResult):void {
		var composite:CompositeCommand = new CompositeCommand();

		for each(var item:Object in result.data) {
			theme.vocabulary.noteTitleHash.clear(item.title);
			composite.addOperation(RemoveNoteCmd, storage, item.id);
		}

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError();
	}

}
}