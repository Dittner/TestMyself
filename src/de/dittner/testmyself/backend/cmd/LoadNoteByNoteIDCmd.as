package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

import mx.collections.ArrayCollection;

public class LoadNoteByNoteIDCmd extends StorageOperation implements IAsyncCommand {

	public function LoadNoteByNoteIDCmd(storage:Storage, vocabulary:Vocabulary, noteID:int) {
		super();
		this.storage = storage;
		this.vocabulary = vocabulary;
		this.noteID = noteID;
	}

	private var storage:Storage;
	private var vocabulary:Vocabulary;
	private var noteID:int;
	private var loadedNote:Note;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.noteID = noteID;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_NOTE_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array)
			for each(var item:Object in result.data) {
				loadedNote = vocabulary.createNote(item);
				loadedNote.deserialize(item);
				break;
			}

		if (!loadedNote) {
			dispatchError("Не удалось загрузить запись!");
			return;
		}

		if (storage.exampleHash[loadedNote.id]) {
			var examples:Array = [];
			var example:Note;
			for each(var exampleData:Object in storage.exampleHash[loadedNote.id]) {
				example = loadedNote.createExample();
				example.deserialize(exampleData);
				examples.push(example);
			}
			loadedNote.exampleColl = new ArrayCollection(examples);
		}
		dispatchSuccess(loadedNote);
	}
}
}