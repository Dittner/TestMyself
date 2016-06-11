package dittner.testmyself.core.command.backend {

import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;

import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLConnection;

public class ExampleInsertOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function ExampleInsertOperationPhase(conn:SQLConnection, note:Note, examples:Array, sqlFactory:SQLFactory) {
		this.note = note;
		this.conn = conn;
		this.examples = examples;
		this.sqlFactory = sqlFactory;
	}

	private var note:Note;
	private var examples:Array;
	private var conn:SQLConnection;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		if (examples && examples.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var example:INote in examples) {
				composite.addOperation(MP3EncodingPhase, example);
				composite.addOperation(ExampleInsertOperationSubPhase, note.id, example, conn, sqlFactory.insertExample);
			}
			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

	override public function destroy():void {
		super.destroy();
		examples = null;
		conn = null;
	}
}
}