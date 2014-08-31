package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.SFModule;
import dittner.testmyself.core.model.note.NoteModel;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.deutsch.model.phrase.PhraseDemoData;

public class ConfigurePhraseModuleCmd implements IConfigureCommand {

	public function execute(phraseModule:SFModule):void {
		//register models and services
		phraseModule.registerProxy("model", new NoteModel(phraseModule.name));
		phraseModule.registerProxy("demoData", new PhraseDemoData());
		phraseModule.registerProxy("service", new NoteService());
	}
}
}