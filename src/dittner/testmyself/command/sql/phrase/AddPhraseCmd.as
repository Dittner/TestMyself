package dittner.testmyself.command.sql.phrase {
import dittner.testmyself.command.sql.common.ThematicTransUnitInsertTransactionPhase;
import dittner.testmyself.command.sql.common.ThemesInsertTransactionPhase;
import dittner.testmyself.command.sql.common.ThemesValidationPhase;
import dittner.testmyself.model.phrase.PhraseSuite;
import dittner.testmyself.command.core.deferredComandManager.DeferredCommand;
import dittner.testmyself.command.core.operation.PhaseRunner;
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.view.common.mediator.RequestMessage;

public class AddPhraseCmd extends DeferredCommand {

	[Embed(source="/dittner/testmyself/command/sql/phrase/statement/InsertPhrase.sql", mimeType="application/octet-stream")]
	private static const InsertPhraseSQLClass:Class;
	private static const INSERT_PHRASE_SQL:String = new InsertPhraseSQLClass();

	[Embed(source="/dittner/testmyself/command/sql/phrase/statement/InsertThematicPhrase.sql", mimeType="application/octet-stream")]
	private static const InsertThematicPhraseSQLClass:Class;
	private static const INSERT_THEMATIC_PHRASE_SQL:String = new InsertThematicPhraseSQLClass();

	[Embed(source="/dittner/testmyself/command/sql/phrase/statement/InsertPhraseTheme.sql", mimeType="application/octet-stream")]
	private static const InsertPhraseThemeSQLClass:Class;
	private static const INSERT_PHRASE_THEME_SQL:String = new InsertPhraseThemeSQLClass();

	[Inject]
	public var service:PhraseService;

	private function get suite():PhraseSuite {
		return (data as RequestMessage).data as PhraseSuite;
	}

	private function get completeCallback():Function {
		return (data as RequestMessage).completeSuccess;
	}

	private function get errorCallback():Function {
		return (data as RequestMessage).completeWithError;
	}

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = completeSuccess;
		phaseRunner.errorCallback = completeWithError;

		phaseRunner.addPhase(PhraseValidationPhase, suite.phrase);
		phaseRunner.addPhase(ThemesValidationPhase, suite.themes);
		phaseRunner.addPhase(PhraseInsertTransactionPhase, suite.phrase, service.sqlRunner, INSERT_PHRASE_SQL);
		phaseRunner.addPhase(ThemesInsertTransactionPhase, suite.themes, service.sqlRunner, INSERT_PHRASE_THEME_SQL);
		phaseRunner.addPhase(ThematicTransUnitInsertTransactionPhase, suite.phrase, suite.themes, service.sqlRunner, INSERT_THEMATIC_PHRASE_SQL);

		phaseRunner.execute();
	}

	private function completeSuccess():void {
		completeCallback(suite);
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
