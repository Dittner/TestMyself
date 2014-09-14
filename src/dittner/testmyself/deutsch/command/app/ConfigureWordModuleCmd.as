package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.SFModule;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.model.note.NoteModel;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.core.service.NoteServiceSpec;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.domain.word.Word;
import dittner.testmyself.deutsch.model.domain.word.WordDemoData;
import dittner.testmyself.deutsch.model.domain.word.WordHash;
import dittner.testmyself.deutsch.model.domain.word.WordSQLFactory;

public class ConfigureWordModuleCmd implements IConfigureCommand {

	public function execute(wordModule:SFModule):void {
		//register models and services
		wordModule.registerProxy("model", createModel());
		wordModule.registerProxy("sqlFactory", new WordSQLFactory());
		var spec:NoteServiceSpec = createSpec();
		wordModule.registerProxy("demoData", spec.demoData as SFProxy);
		wordModule.registerProxy("spec", spec);
		wordModule.registerProxy("service", new NoteService());
	}

	private function createModel():NoteModel {
		var model:NoteModel = new NoteModel();
		model.noteHash = new WordHash();
		return model;
	}

	private function createSpec():NoteServiceSpec {
		var spec:NoteServiceSpec = new NoteServiceSpec();
		spec.dbName = ModuleName.WORD;
		spec.noteClass = Word;
		spec.demoData = new WordDemoData();
		return spec;
	}
}
}