package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.core.deferredOperation.DeferredOperation;
import dittner.testmyself.model.phrase.Phrase;

import flash.data.SQLResult;

public class SelectPhraseSQLOperation extends DeferredOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectPhraseSQLClass:Class;
	private static const SELECT_PHRASE_SQL:String = new SelectPhraseSQLClass();

	public function SelectPhraseSQLOperation(sqlRunner:SQLRunner, completeCallback:Function) {
		super();
		this.completeCallback = completeCallback;
		this.sqlRunner = sqlRunner;
	}

	private var sqlRunner:SQLRunner;
	private var completeCallback:Function;

	override public function process():void {
		sqlRunner.execute(SELECT_PHRASE_SQL, null, phrasesLoadedHandler, Phrase);
	}

	private function phrasesLoadedHandler(result:SQLResult):void {
		completeCallback(result.data);
		dispatchComplete();
	}
}
}