package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.*;
import de.dittner.testmyself.backend.utils.*;
import de.dittner.testmyself.model.domain.note.IrregularVerb;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.Word;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class ReplaceTextInNoteTblCmd extends StorageOperation implements IAsyncCommand {

	public function ReplaceTextInNoteTblCmd(storage:Storage, srcText:String, destText:String, langID:uint) {
		super();
		this.storage = storage;
		this.srcText = srcText;
		this.destText = destText || "";
		this.langID = langID;
		this.pattern = new RegExp(srcText, "g");
	}

	private var storage:Storage;
	private var srcText:String = "";
	private var destText:String = "";
	private var pattern:RegExp;
	private var langID:int;

	public function execute():void {
		searchNotes();
	}

	private function searchNotes():void {
		if (!srcText) {
			dispatchSuccess();
			return;
		}

		var sql:String = "SELECT * FROM note WHERE langID = " + langID + " AND searchText LIKE " + "'%" + srcText.toLowerCase() + "%'";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private var notesToUpdate:Array = [];
	private function executeComplete(result:SQLResult):void {
		for each(var obj:Object in result.data) {
			notesToUpdate.push(obj);
		}
		storeNextNote();
	}

	private var curNote:Object;
	private function storeNextNote(result:SQLResult = null):void {
		if (notesToUpdate.length > 0) {
			curNote = notesToUpdate.pop();
			storeNote(curNote);
		}
		else {
			dispatchSuccess()
		}
	}

	private function storeNote(curNote:Object):void {
		var sql:String = "UPDATE note SET title = :title, description = :description, options = :options, searchText = :searchText WHERE id = :id";
		var sqlParams:Object = {};
		var options:Object;
		sqlParams.id = curNote.id;
		sqlParams.title = replaceText(curNote.title);
		sqlParams.description = replaceText(curNote.description);
		options = replaceTextInObj(curNote.options) || {};
		sqlParams.options = options;

		if (isWord(curNote)) {
			sqlParams.searchText = Word.toSearchText(options.article, sqlParams.title, options.declension, sqlParams.description);
		}
		else if (isVerb(curNote)) {
			sqlParams.searchText = IrregularVerb.toSearchText(sqlParams.title, options.present, options.past, options.perfect, sqlParams.description);
		}
		else {
			sqlParams.searchText = Note.toSearchText(sqlParams.title, sqlParams.description);
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(storeNextNote, executeError));
	}

	private function replaceText(txt:String):String {
		return txt.replace(pattern, destText);
	}

	private function replaceTextInObj(obj:Object):Object {
		if (obj)
			for (var prop:String in obj)
				if (obj[prop] is String)  obj[prop] = replaceText(obj[prop] as String);
		return obj;
	}

	private function isWord(obj:Object):Boolean {
		return !obj.isExample && (obj.vocabularyID == VocabularyID.DE_WORD || obj.vocabularyID == VocabularyID.EN_WORD);
	}

	private function isVerb(obj:Object):Boolean {
		return !obj.isExample && (obj.vocabularyID == VocabularyID.DE_VERB || obj.vocabularyID == VocabularyID.EN_VERB);
	}

}
}
