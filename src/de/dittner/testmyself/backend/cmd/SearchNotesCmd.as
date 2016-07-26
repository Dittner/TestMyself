package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.op.CountNotesBySearchOperationPhase;
import de.dittner.testmyself.backend.op.SelectExamplesByPageSQLOperation;
import de.dittner.testmyself.backend.op.SelectNotesBySearchOperationPhase;
import de.dittner.testmyself.backend.op.SelectThemesByPageSQLOperation;
import de.dittner.testmyself.ui.common.page.SearchPageInfo;

public class SearchNotesCmd extends AsyncOperation implements IAsyncCommand {

	public function SearchNotesCmd(storage:SQLStorage, page:SearchPageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:SQLStorage;
	private var page:SearchPageInfo;

	public function execute():void {
		if (!page.loadExamples && page.vocabularyIDs.length == 0) {
			page.allNotesAmount = 0;
			page.notes = [];
			dispatchSuccess(page);
			return;
		}

		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(SelectNotesBySearchOperationPhase, storage, page);
		composite.addOperation(SelectExamplesByPageSQLOperation, storage, page);
		composite.addOperation(SelectThemesByPageSQLOperation, storage, page);
		composite.addOperation(CountNotesBySearchOperationPhase, storage, page);

		composite.addCompleteCallback(completeHandler);
		composite.execute();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(page);
		else dispatchError(op.error);
	}
}
}