package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.CompositeCommand;
import dittner.async.IAsyncCommand;
import dittner.async.IAsyncOperation;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;

import flash.data.SQLConnection;

public class TestTaskInsertOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function TestTaskInsertOperationPhase(conn:SQLConnection, note:Note, examples:Array, testModel:TestModel, sqlFactory:SQLFactory) {
		this.note = note;
		this.examples = examples;
		this.conn = conn;
		this.testModel = testModel;
		this.sqlFactory = sqlFactory;
	}

	private var note:Note;
	private var examples:Array;
	private var testModel:TestModel;
	private var conn:SQLConnection;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		if (testModel && testModel.testInfos.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var info:TestInfo in testModel.testInfos) {
				if (info.useNoteExample) {
					for each(var noteExample:INote in examples)
						composite.addOperation(TestTaskInsertOperationSubPhase, noteExample, info, conn, sqlFactory.insertTestExampleTask, testModel);
				}
				else {
					composite.addOperation(TestTaskInsertOperationSubPhase, note, info, conn, sqlFactory.insertTestTask, testModel);
				}
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
		note = null;
		testModel = null;
		examples = null;
		conn = null;
	}
}
}