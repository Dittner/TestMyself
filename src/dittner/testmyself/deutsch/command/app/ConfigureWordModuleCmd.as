package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.SFModule;
import dittner.testmyself.core.model.note.NoteModel;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.deutsch.model.word.WordDemoData;

public class ConfigureWordModuleCmd implements IConfigureCommand {

	public function execute(wordModule:SFModule):void {
		//register models and services
		wordModule.registerProxy("model", new NoteModel(wordModule.name));
		wordModule.registerProxy("demoData", new WordDemoData());
		wordModule.registerProxy("service", new NoteService());
	}
}
}