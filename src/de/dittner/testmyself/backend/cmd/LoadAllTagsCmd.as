package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class LoadAllTagsCmd extends StorageOperation implements IAsyncCommand {

	public function LoadAllTagsCmd(storage:Storage, vocabulary:Vocabulary) {
		super();
		this.storage = storage;
		this.vocabulary = vocabulary;
	}

	private var storage:Storage;
	private var vocabulary:Vocabulary;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_TAG_SQL, {vocabularyID: vocabulary.id});
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		var tags:Array = [];
		if (result.data is Array)
			for each(var item:Object in result.data) {
				var t:Tag = vocabulary.createTag();
				t.deserialize(item);
				tags.push(t);
			}

		dispatchSuccess(tags);
	}
}
}