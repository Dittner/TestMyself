package de.dittner.testmyself.backend.operation {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.note.SQLLib;
import de.dittner.testmyself.model.domain.test.Test;

import flash.data.SQLConnection;

public class ClearTestHistoryOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function ClearTestHistoryOperationPhase(conn:SQLConnection, testInfo:Test, noteIDs:Array, testModel:TestModel, sqlFactory:SQLLib) {
		this.noteIDs = noteIDs;
		this.conn = conn;
		this.testModel = testModel;
		this.testInfo = testInfo;
		this.sqlFactory = sqlFactory;
	}

	private var noteIDs:Array;
	private var testModel:TestModel;
	private var testInfo:Test;
	private var conn:SQLConnection;
	private var sqlFactory:SQLLib;
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