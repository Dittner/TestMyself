package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.theme.Theme;

import flash.data.SQLResult;

public class SelectPhraseSQLOperation extends DeferredOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectFilteredPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectFilteredPhraseSQLClass:Class;
	private static const SELECT_FILTERED_PHRASE_SQL:String = new SelectFilteredPhraseSQLClass();

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectAllPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectAllPhraseSQLClass:Class;
	private static const SELECT_ALL_PHRASE_SQL:String = new SelectAllPhraseSQLClass();

	public function SelectPhraseSQLOperation(sqlRunner:SQLRunner, filter:Vector.<Object>) {
		super();
		this.sqlRunner = sqlRunner;
		this.filter = filter;
	}

	private var sqlRunner:SQLRunner;
	private var filter:Vector.<Object>;

	override public function process():void {
		if (filter.length > 0) {
			var themes:String = getThemesEnum(filter);
			sqlRunner.execute(SELECT_FILTERED_PHRASE_SQL + themes, null, phrasesLoadedHandler, Phrase);
		}
		else {
			sqlRunner.execute(SELECT_ALL_PHRASE_SQL, null, phrasesLoadedHandler, Phrase);
		}
	}

	private function getThemesEnum(filter:Vector.<Object>):String {
		var res:String = "(";
		for (var i:int = 0; i < filter.length; i++) {
			var theme:Theme = filter[i] as Theme;
			res += "'" + theme.name + "'";
			if (i < filter.length - 1) res += ","
		}
		res += ")";
		return res;
	}

	private function phrasesLoadedHandler(result:SQLResult):void {
		var phrases:Array = result.data is Array ? result.data as Array : [];
		dispatchCompleteSuccess(new CommandResult(phrases));
	}
}
}