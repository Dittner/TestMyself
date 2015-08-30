package dittner.testmyself.core.command.backend {

import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.CompositeOperation;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;

import flash.data.SQLConnection;

public class AllTestTaskInsertOperationPhase extends AsyncOperation implements ICommand {

	public function AllTestTaskInsertOperationPhase(conn:SQLConnection, notes:Array, testModel:TestModel, sqlFactory:SQLFactory, isExample:Boolean) {
		this.notes = notes;
		this.conn = conn;
		this.testModel = testModel;
		this.sqlFactory = sqlFactory;
		this.isExample = isExample;
	}

	private var notes:Array;
	private var testModel:TestModel;
	private var conn:SQLConnection;
	private var sqlFactory:SQLFactory;
	private var composite:CompositeOperation;
	private var isExample:Boolean;

	public function execute():void {
		if (testModel && testModel.testInfos.length > 0) {
			composite = new CompositeOperation();
			var info:TestInfo;
			if (isExample) {
				for each(info in testModel.testInfos) {
					if (info.useNoteExample) {
						for each(var example:INote in notes) {
							composite.addOperation(TestTaskInsertOperationSubPhase, example, info, conn, sqlFactory.insertTestExampleTask, testModel);
						}
					}
				}
			}
			else {
				for each(info in testModel.testInfos) {
					if (!info.useNoteExample) {
						for each(var note:INote in notes) {
							composite.addOperation(TestTaskInsertOperationSubPhase, note, info, conn, sqlFactory.insertTestTask, testModel);
						}
					}
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
		notes.length = 0;
		notes = null;
		testModel = null;
		conn = null;
		composite = null;
	}
}
}