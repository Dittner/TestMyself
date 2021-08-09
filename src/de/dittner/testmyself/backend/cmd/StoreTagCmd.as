package de.dittner.testmyself.backend.cmd {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.tag.Tag;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class StoreTagCmd extends StorageOperation implements IAsyncCommand {

	public function StoreTagCmd(storage:Storage, tag:Tag) {
		super();
		this.storage = storage;
		this.tag = tag;
	}

	private var storage:Storage;
	private var tag:Tag;

	public function execute():void {
		if (!tag) {
			dispatchError(ErrorCode.NULLABLE_TAG + ": Отсутствует добавляемая тема");
			return
		}

		var sqlParams:Object = tag.serialize();
		var statement:SQLStatement;

		if (tag.isNew) {
			statement = SQLUtils.createSQLStatement(SQLLib.INSERT_TAG_SQL, sqlParams);
		}
		else {
			sqlParams.tagID = tag.id;
			statement = SQLUtils.createSQLStatement(SQLLib.UPDATE_TAG_SQL, sqlParams);
		}

		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));

	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			if (tag.isNew) tag.id = result.lastInsertRowID;
			tag.vocabulary.addTag(tag);
			dispatchSuccess();
		}
		else {
			dispatchError(ErrorCode.TAG_ADDED_WITHOUT_ID + ": База данных не вернула ID добавленной темы");
		}
	}
}
}