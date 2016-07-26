package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLConnection;

public class InsertFilterOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function InsertFilterOperationPhase(conn:SQLConnection, note:Note) {
		this.conn = conn;
		this.note = note;
	}

	private var note:Note;
	private var conn:SQLConnection;

	public function execute():void {
		if (note.themeIDs.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var theme:Theme in note.themeIDs)
				composite.addOperation(InsertFilterOperationSubPhase, note.id, theme, conn, SQLLib.INSERT_FILTER_SQL);

			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}
}
}
