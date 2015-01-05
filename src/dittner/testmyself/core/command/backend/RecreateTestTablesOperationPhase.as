package dittner.testmyself.core.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class RecreateTestTablesOperationPhase extends PhaseOperation {

	public function RecreateTestTablesOperationPhase(sqlRunner:SQLRunner, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
		statements.push(new QueuedStatement("DROP TABLE test"));
		statements.push(new QueuedStatement("DROP TABLE testExample"));
		statements.push(new QueuedStatement(sqlFactory.createTestTbl));
		statements.push(new QueuedStatement(sqlFactory.createTestExampleTbl));

		sqlRunner.executeModify(statements, executeComplete, deleteFailedHandler, null);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function deleteFailedHandler(error:SQLError):void {
		dispatchComplete();
	}

	override public function destroy():void {
		super.destroy();
		sqlFactory = null;
		sqlRunner = null;
	}
}
}