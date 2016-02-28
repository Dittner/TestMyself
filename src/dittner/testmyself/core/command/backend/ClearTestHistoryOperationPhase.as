package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.CompositeCommand;
import dittner.async.IAsyncCommand;
import dittner.async.IAsyncOperation;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;

import flash.data.SQLConnection;

public class ClearTestHistoryOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function ClearTestHistoryOperationPhase(conn:SQLConnection, testInfo:TestInfo, noteIDs:Array, testModel:TestModel, sqlFactory:SQLFactory) {
		this.noteIDs = noteIDs;
		this.conn = conn;
		this.testModel = testModel;
		this.testInfo = testInfo;
		this.sqlFactory = sqlFactory;
	}

	private var noteIDs:Array;
	private var testModel:TestModel;
	private var testInfo:TestInfo;
	private var conn:SQLConnection;
	private var sqlFactory:SQLFactory;
	private var composite:CompositeCommand;

	public function execute():void {
		if (noteIDs.length > 0) {
			composite = new CompositeCommand();

			for each(var noteID:int in noteIDs) {
				composite.addOperation(ClearTestHistoryOperationSubPhase, testInfo.id, noteID, conn, sqlFactory.updateTestTask, testModel);
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
		sqlFactory = null;
		testModel = null;
		conn = null;
		testInfo = null;
		composite = null;
	}
}
}