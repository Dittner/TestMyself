package dittner.testmyself.command.phrase {
import dittner.testmyself.command.DeferredCommand;
import dittner.testmyself.model.phrase.PhraseVo;
import dittner.testmyself.service.operation.CompositePhase;
import dittner.testmyself.service.phrase.PhraseService;
import dittner.testmyself.service.phrase.operation.add.AddPhrasePrevalidationPhase;
import dittner.testmyself.service.phrase.operation.add.AddPhraseTransactionPhase;
import dittner.testmyself.view.common.mediator.RequestMessage;

public class AddPhraseCmd extends DeferredCommand {

	[Embed(source="/dittner/testmyself/service/phrase/sql/AddPhraseStatement.sql", mimeType="application/octet-stream")]
	private static const AddPhraseStatementClass:Class;
	private static const ADD_PHRASE_STATEMENT:String = new AddPhraseStatementClass();

	[Inject]
	public var service:PhraseService;

	private function get phrase():PhraseVo {
		return (data as RequestMessage).data as PhraseVo;
	}

	private function get completeCallback():Function {
		return (data as RequestMessage).complete;
	}

	private function get errorCallback():Function {
		return (data as RequestMessage).error;
	}

	override public function process():void {
		var compositePhase:CompositePhase = new CompositePhase();
		compositePhase.completeCallback = completeSuccess;
		compositePhase.errorCallback = completeWithError;

		compositePhase
				.addPhase(new AddPhrasePrevalidationPhase(phrase))
				.addPhase(new AddPhraseTransactionPhase(phrase, service.sqlRunner, ADD_PHRASE_STATEMENT));

		compositePhase.execute();
	}

	private function completeSuccess():void {
		completeCallback(phrase);
		dispatchComplete();
	}

	private function completeWithError(msg:String):void {
		errorCallback(msg);
		dispatchComplete();
	}

	override public function destroy():void {
		data = null;
	}

}
}
