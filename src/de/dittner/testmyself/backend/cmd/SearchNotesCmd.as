package de.dittner.testmyself.backend.cmd {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.CountNotesBySearchOperation;
import de.dittner.testmyself.backend.op.SelectNotesBySearchOperation;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.model.domain.note.Note;
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
	private var notes:Array = [];

	public function execute():void {
		if (!page.loadExamples && page.vocabularyIDs.length == 0) {
			page.allNotesAmount = 0;
			page.coll = new ArrayCollection();
			dispatchSuccess(page);
			return;
		}

		var composite:CompositeCommand = new CompositeCommand();

		if(page.number == 0 && !hasSearchTextDelimiter())
			composite.addOperation(SelectNotesBySearchOperation, storage, page, notes, true);

		composite.addOperation(SelectNotesBySearchOperation, storage, page, notes, false);
		if (page.countAllNotes)
			composite.addOperation(CountNotesBySearchOperation, storage, page);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function hasSearchTextDelimiter():Boolean {
		return page.searchText && (page.searchText.charAt(0) == Note.SEARCH_DELIMITER || page.searchText.charAt(page.searchText.length - 1) == Note.SEARCH_DELIMITER);
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) {
			page.coll = new ArrayCollection(notes);
			dispatchSuccess(page);
		}
		else {
			dispatchError();
		}
	}
}
}