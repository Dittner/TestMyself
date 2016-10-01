package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.tag.Tag;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class UpdateNotesTagsOperation extends StorageOperation implements IAsyncCommand {

	public function UpdateNotesTagsOperation(storage:Storage, removedTag:Tag, mergeToTag:Tag = null) {
		super();
		this.storage = storage;
		this.removedTag = removedTag;
		this.mergeToTag = mergeToTag;
	}

	private var storage:Storage;
	private var removedTag:Tag;
	private var mergeToTag:Tag;

	public function execute():void {
		if (removedTag.id == -1) {
			dispatchError(ErrorCode.NULLABLE_NOTE + ": No removing tag's ID");
		}
		else {
			selectNoteIDsWithTag(removedTag);
		}
	}

	private function selectNoteIDsWithTag(tag:Tag):void {
		var sql:String = "SELECT id,tags FROM note WHERE tags LIKE :tagID";
		var sqlParams:Object = {};
		sqlParams.tagID = "%" + Tag.DELIMITER + tag.id + Tag.DELIMITER + "%";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private var noteToUpdate:Array = [];
	private function executeComplete(result:SQLResult):void {
		noteToUpdate = result.data;
		updateNextNote();
	}

	private var curNoteData:Object;
	private function updateNextNote(result:SQLResult = null):void {
		if (noteToUpdate && noteToUpdate.length > 0) {
			curNoteData = noteToUpdate.pop();
			updateNote(curNoteData.id, curNoteData.tags);
		}
		else {
			dispatchSuccess();
		}
	}

	private function updateNote(noteID:int, tags:String):void {
		var sql:String = "UPDATE note SET tags = :tags WHERE id = :noteID";
		var sqlParams:Object = {};
		sqlParams.noteID = noteID;
		sqlParams.tags = tags.replace(removedTag.id + Tag.DELIMITER, "");
		if (sqlParams.tags == Tag.DELIMITER)
			sqlParams.tags = null;

		if (mergeToTag) {
			if (sqlParams.tags) {
				if (sqlParams.tags.indexOf(Tag.DELIMITER + mergeToTag.id + Tag.DELIMITER) == -1)
					sqlParams.tags += mergeToTag.id + Tag.DELIMITER;
			}
			else
				sqlParams.tags = Tag.DELIMITER + mergeToTag.id + Tag.DELIMITER;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(updateNextNote, executeError));
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}