package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.tag.Tag;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class DeleteTagOperation extends StorageOperation implements IAsyncCommand {

	public function DeleteTagOperation(storage:Storage, tag:Tag) {
		super();
		this.storage = storage;
		this.tag = tag;
	}

	private var storage:Storage;
	private var tag:Tag;

	public function execute():void {
		if (tag.id == -1) {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": No removing tag's ID");
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_TAG_SQL, {deletingTagID: tag.id});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(deleteCompleteHandler, executeError));
		}
	}

	private function deleteCompleteHandler(result:SQLResult):void {
		tag.vocabulary.removeTag(tag);
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}