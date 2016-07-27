package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.SelectExamplesOperation;
import de.dittner.testmyself.backend.op.SelectNoteThemesOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class LoadNoteByNoteIDCmd extends AsyncOperation implements IAsyncCommand {

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
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data is Array)
			for each(var item:Object in result.data) {
				loadedNote = vocabulary.createNote();
				loadedNote.deserialize(item);
				break;
			}

		if (!loadedNote) {
			CLog.err(LogCategory.STORAGE, "Не удалось загрузить запись в LoadNoteByNoteIDCmd");
			dispatchError();
			return;
		}

		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectExamplesOperation, storage, loadedNote);
		composite.addOperation(SelectNoteThemesOperation, storage, loadedNote);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(loadedNote);
		else dispatchError(op.error);
	}
}
}