package de.dittner.testmyself.backend.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class LoadAllThemesCmd extends AsyncOperation implements IAsyncCommand {

	public function LoadAllThemesCmd(storage:SQLStorage, vocabulary:Vocabulary) {
		super();
		this.storage = storage;
		this.vocabulary = vocabulary;
	}

	private var storage:SQLStorage;
	private var vocabulary:Vocabulary;

	public function execute():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_THEME_SQL, {vocabularyID: vocabulary.id});
		statement.sqlConnection = storage.sqlConnection;
		statement.itemClass = Theme;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess(result.data);
	}
}
}