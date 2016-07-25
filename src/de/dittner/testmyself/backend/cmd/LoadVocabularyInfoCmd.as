package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.operation.*;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;

public class LoadVocabularyInfoCmd extends AsyncOperation implements IAsyncCommand {

	public function LoadVocabularyInfoCmd(service:SQLStorage, vocabulary:Vocabulary) {
		this.service = service;
		info = new VocabularyInfo();
		info.vocabulary = vocabulary;
	}

	private var service:SQLStorage;
	private var info:VocabularyInfo;

	public function execute():void {
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(NoteCountOperationPhase, service.sqlConnection, info);
		composite.addOperation(AudioCommentCountOperationPhase, service.sqlConnection, info);
		composite.addOperation(ExampleCountOperationPhase, service.sqlConnection, info);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(info);
		else dispatchError(op.error);
	}
}
}