package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class LoadAllExamplesOperation extends StorageOperation implements IAsyncCommand {

	public function LoadAllExamplesOperation(storage:Storage) {
		this.storage = storage;
		this.info = info;
	}

	private var info:VocabularyInfo;
	private var storage:Storage;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_ALL_EXAMPLES_SQL);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			for each(var item:Object in result.data) {
				if (storage.exampleHash[item.parentID])
					storage.exampleHash[item.parentID].push(item);
				else
					storage.exampleHash[item.parentID] = [item];
			}
		}
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		storage = null;
	}
}
}
