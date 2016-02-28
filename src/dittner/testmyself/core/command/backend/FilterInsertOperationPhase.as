package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.CompositeCommand;
import dittner.async.IAsyncCommand;
import dittner.async.IAsyncOperation;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.theme.Theme;

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
