package dittner.testmyself.service.phrase.operation.add {
import dittner.testmyself.model.phrase.PhraseVo;
import dittner.testmyself.service.operation.Phase;
import dittner.testmyself.service.operation.PhaseErrorCode;

public class AddPhrasePrevalidationPhase extends Phase {
	public function AddPhrasePrevalidationPhase(phrase:PhraseVo) {
		super();
		this.phrase = phrase;
	}

	public var phrase:PhraseVo;

	override protected function process():void {
		if(!phrase) completeWithError(PhaseErrorCode.NO_DATA_TO_HANDLE);
		else if (phrase.origin && phrase.translation) completeSuccess();
		else completeWithError(PhaseErrorCode.FORM_NOT_FILLED);
	}
}
}
