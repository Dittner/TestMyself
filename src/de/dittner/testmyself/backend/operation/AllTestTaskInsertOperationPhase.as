package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.op.InsertTestTaskOperationSubPhase;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.test.Test;

import flash.data.SQLConnection;

public class AllTestTaskInsertOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function AllTestTaskInsertOperationPhase(conn:SQLConnection, notes:Array, testModel:TestModel, sqlFactory:SQLLib, isExample:Boolean) {
		this.notes = notes;
		this.conn = conn;
		this.testModel = testModel;
		this.sqlFactory = sqlFactory;
		this.isExample = isExample;
	}

	private var notes:Array;
	private var testModel:TestModel;
	private var conn:SQLConnection;
	private var sqlFactory:SQLLib;
	private var composite:CompositeCommand;
	private var isExample:Boolean;

	public function execute():void {
		if (testModel && testModel.testInfos.length > 0) {
			composite = new CompositeCommand();
			var info:Test;
			if (isExample) {
				for each(info in testModel.testInfos) {
					if (info.useExamples) {
						for each(var example:INote in notes) {
							composite.addOperation(InsertTestTaskOperationSubPhase, example, info, conn, sqlFactory.insertTestExampleTask, testModel);
						}
					}
				}
			}
			else {
				for each(info in testModel.testInfos) {
					if (!info.useExamples) {
						for each(var note:INote in notes) {
							composite.addOperation(InsertTestTaskOperationSubPhase, note, info, conn, sqlFactory.insertTestTask, testModel);
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