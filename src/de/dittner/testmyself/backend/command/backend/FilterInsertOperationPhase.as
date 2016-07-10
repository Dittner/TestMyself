package de.dittner.testmyself.backend.command.backend {

import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.SQLFactory;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLConnection;

public class FilterInsertOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function FilterInsertOperationPhase(conn:SQLConnection, note:Note, themes:Array, sqlFactory:SQLFactory) {
		this.conn = conn;
		this.note = note;
		this.themes = themes;
		this.sqlFactory = sqlFactory;
	}

	private var note:Note;
	private var themes:Array;
	private var sqlFactory:SQLFactory;
	private var conn:SQLConnection;

	public function execute():void {
		if (themes.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var theme:Theme in themes)
				composite.addOperation(FilterInsertOperationSubPhase, note.id, theme, conn, sqlFactory.insertFilter);

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
