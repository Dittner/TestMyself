package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.deferredOperation.ErrorCode;

import flash.data.SQLResult;

public class SelectThematicPhraseSQLOperation extends DeferredOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectThematicPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectThematicPhraseSQLClass:Class;
	private static const SELECT_THEMATIC_PHRASE_SQL:String = new SelectThematicPhraseSQLClass();

	public function SelectThematicPhraseSQLOperation(sqlRunner:SQLRunner, phraseID:int) {
		super();
		this.sqlRunner = sqlRunner;
		this.phraseID = phraseID;
	}

	private var sqlRunner:SQLRunner;
	private var phraseID:int;

	override public function process():void {
		if (phraseID) {
			sqlRunner.execute(SELECT_THEMATIC_PHRASE_SQL, {selectedPhraseID: phraseID}, loadCompleteHandler);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.NULL_TRANS_UNIT, "Отсутствует ID фразы"));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var themesID:Array = [];
		for each(var item:Object in result.data) themesID.push(item.themeID);
		dispatchCompleteSuccess(new CommandResult(themesID));
	}
}
}