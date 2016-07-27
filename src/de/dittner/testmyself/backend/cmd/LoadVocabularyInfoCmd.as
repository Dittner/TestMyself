package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.CountAudioCommentOperation;
import de.dittner.testmyself.backend.op.CountExampleOperation;
import de.dittner.testmyself.backend.op.CountNoteOperation;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;

public class LoadVocabularyInfoCmd extends AsyncOperation implements IAsyncCommand {

	public function LoadVocabularyInfoCmd(storage:SQLStorage, vocabulary:Vocabulary) {
		this.storage = storage;
		info = new VocabularyInfo();
		info.vocabulary = vocabulary;
	}

	private var storage:SQLStorage;
	private var info:VocabularyInfo;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(CountNoteOperation, storage.sqlConnection, info);
		composite.addOperation(CountAudioCommentOperation, storage.sqlConnection, info);
		composite.addOperation(CountExampleOperation, storage.sqlConnection, info);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(info);
		else dispatchError(op.error);
	}
}
}