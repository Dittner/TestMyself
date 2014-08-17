package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.SQLUtils;
import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.phrase.PhrasePageInfo;

import flash.data.SQLResult;

public class SelectPhraseSQLOperation extends DeferredOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectFilteredPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPhraseSQLClass:Class;
	private static const SELECT_FILTERED_PHRASE_SQL:String = new SelectFilteredPhraseSQLClass();

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectPhraseSQLClass:Class;
	private static const SELECT_PHRASE_SQL:String = new SelectPhraseSQLClass();

	public function SelectPhraseSQLOperation(sqlRunner:SQLRunner, pageInfo:PhrasePageInfo) {
		super();
		this.sqlRunner = sqlRunner;
		this.pageInfo = pageInfo;
	}

	private var sqlRunner:SQLRunner;
	private var pageInfo:PhrasePageInfo;

	override public function process():void {
		var params:Object = {};
		params.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		params.amount = pageInfo.pageSize;

		if (pageInfo.filter.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(pageInfo.filter);
			var statement:String = SELECT_FILTERED_PHRASE_SQL;
			statement = statement.replace("#filterList", themes);
			sqlRunner.execute(statement, params, phrasesLoadedHandler, Phrase);
		}
		else {
			sqlRunner.execute(SELECT_PHRASE_SQL, params, phrasesLoadedHandler, Phrase);
		}
	}

	private function phrasesLoadedHandler(result:SQLResult):void {
		pageInfo.phrases = result.data is Array ? result.data as Array : [];
		dispatchCompleteSuccess(new CommandResult(pageInfo));
	}
}
}