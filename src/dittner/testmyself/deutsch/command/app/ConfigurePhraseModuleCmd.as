package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.SFModule;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.model.note.NoteModel;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.core.service.NoteServiceSpec;
import dittner.testmyself.deutsch.model.domain.phrase.PhraseDemoData;

public class ConfigurePhraseModuleCmd implements IConfigureCommand {

	public function execute(phraseModule:SFModule):void {
		//register models and services
		phraseModule.registerProxy("model", new NoteModel());
		phraseModule.registerProxy("sqlFactory", new SQLFactory());
		var spec:NoteServiceSpec = createSpec();
		phraseModule.registerProxy("demoData", spec.demoData as SFProxy);
		phraseModule.registerProxy("spec", spec);
		phraseModule.registerProxy("service", new NoteService());
	}

	private function createSpec():NoteServiceSpec {
		var spec:NoteServiceSpec = new NoteServiceSpec();
		spec.dbName = "phrase";
		spec.demoData = new PhraseDemoData();
		return spec;
	}
}
}