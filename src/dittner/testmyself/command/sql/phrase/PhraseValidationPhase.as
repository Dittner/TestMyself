package dittner.testmyself.command.sql.phrase {
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.command.core.operation.PhaseOperation;
import dittner.testmyself.command.core.operation.SQLErrorCode;

public class PhraseValidationPhase extends PhaseOperation {
	public function PhraseValidationPhase(phrase:Phrase) {
		this.phrase = phrase;
	}

	private var phrase:Phrase;

	override public function execute():void {
		if (!phrase) completeWithError(SQLErrorCode.NULL_TRANS_UNIT);
		else if (phrase.origin && phrase.translation) completeSuccess();
		else completeWithError(SQLErrorCode.FORM_NOT_FILLED);
	}

	override protected function destroy():void {
		super.destroy();
		phrase = null;
	}
}
}
