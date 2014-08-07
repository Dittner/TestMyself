package dittner.testmyself.command.sql.phrase {
import dittner.testmyself.model.model_internal;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.command.core.deferredComandManager.DeferredCommand;
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.RequestMessage;

import flash.data.SQLResult;

use namespace model_internal;

public class GetPhrasesCmd extends DeferredCommand {

	[Embed(source="/dittner/testmyself/command/sql/phrase/statement/SelectPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectPhraseSQLClass:Class;
	private static const SELECT_PHRASE_SQL:String = new SelectPhraseSQLClass();

	[Inject]
	public var service:PhraseService;

	private function get completeCallback():Function {
		return (data as RequestMessage).completeSuccess;
	}

	private function get errorCallback():Function {
		return (data as RequestMessage).completeWithError;
	}

	override public function process():void {
		service.sqlRunner.execute(SELECT_PHRASE_SQL, null, completeSuccess);
	}

	private function completeSuccess(result:SQLResult):void {
		var phrases:Array = [];
		var phrase:Phrase;
		if (result.data && result.data.length > 0) {
			for each(var item:* in result.data) {
				phrase = new Phrase();
				phrase._id = item.id;
				phrase._origin = item.origin;
				phrase._translation = item.translation;
				phrases.push(phrase);
			}
		}
		completeCallback(phrases);
		dispatchComplete();
	}
}
}