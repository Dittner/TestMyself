package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.CountNotesBySearchOperation;
import de.dittner.testmyself.backend.op.SelectExamplesByPageOperation;
import de.dittner.testmyself.backend.op.SelectNotesBySearchOperation;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.ui.common.page.SearchPage;

import mx.collections.ArrayCollection;

public class SearchNotesCmd extends StorageOperation implements IAsyncCommand {

	public function SearchNotesCmd(storage:Storage, page:SearchPage) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:SearchPage;

	public function execute():void {
		if (!page.loadExamples && page.vocabularyIDs.length == 0) {
			page.allNotesAmount = 0;
			page.noteColl = new ArrayCollection();
			dispatchSuccess(page);
			return;
		}

		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectNotesBySearchOperation, storage, page);
		composite.addOperation(SelectExamplesByPageOperation, storage, page);
		if (page.countAllNotes)
			composite.addOperation(CountNotesBySearchOperation, storage, page);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(page);
		else dispatchError();
	}
}
}