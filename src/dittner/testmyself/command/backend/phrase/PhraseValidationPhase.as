package dittner.testmyself.command.backend.phrase {
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.model.phrase.Phrase;

public class PhraseValidationPhase extends PhaseOperation {
	public function PhraseValidationPhase(phrase:Phrase) {
		this.phrase = phrase;
	}

	private var phrase:Phrase;

	override public function execute():void {
		if (!phrase)
			throw new CommandException(ErrorCode.NULL_TRANS_UNIT, "Отсутствует фраза как объект");
		else if (phrase.origin && phrase.translation)
			dispatchComplete();
		else
			throw new CommandException(ErrorCode.FORM_NOT_FILLED, "Форма не заполнена: исходный текст и перевод не должны быть пустыми");
	}

	override public function destroy():void {
		super.destroy();
		phrase = null;
	}
}
}
