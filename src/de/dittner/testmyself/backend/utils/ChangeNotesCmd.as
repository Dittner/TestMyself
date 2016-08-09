package de.dittner.testmyself.backend.utils {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.*;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class ChangeNotesCmd extends StorageOperation implements IAsyncCommand {

	public function ChangeNotesCmd(storage:Storage) {
		super();
		this.storage = storage;
	}

	private var storage:Storage;
	private var noteItems:Array;

	public function execute():void {
		var sql:String = "SELECT * FROM note";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		noteItems = result.data as Array || [];
		changeNextNote();
	}

	private function changeNextNote(result:SQLResult = null):void {
		if (noteItems.length > 0) {
			var item:Object = noteItems.pop();
			var sql:String = "UPDATE note SET searchText = :searchText WHERE id = :updatingNoteID";
			var sqlParams:Object = {};
			sqlParams.searchText = getSearchText(item);
			sqlParams.updatingNoteID = item.id;

			var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(changeNextNote, executeError));
		}
		else {
			dispatchSuccess();
		}
	}

	private function getSearchText(noteItem:Object):String {
		var res:String = "+" + noteItem.title + "+" + noteItem.description + "+";

		if (noteItem.vocabularyID == VocabularyID.DE_WORD) {
			if (noteItem.options.declension)
				res = "+" + noteItem.title + "+" + noteItem.options.declension + "+" + noteItem.description + "+";
			if (noteItem.options.article)
				res = "+" + noteItem.options.article + res;
		}
		else if (noteItem.vocabularyID == VocabularyID.DE_VERB) {
			res = "+" + noteItem.title + "+" + noteItem.options.present + "+" + noteItem.options.past + "+" + noteItem.options.perfect + "+" + noteItem.description + "+";
		}

		return res;
	}
}
}
