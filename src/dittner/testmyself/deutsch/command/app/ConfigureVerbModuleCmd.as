package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.SFModule;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.model.note.NoteModel;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.core.service.NoteServiceSpec;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.domain.common.TestID;
import dittner.testmyself.deutsch.model.domain.verb.Verb;
import dittner.testmyself.deutsch.model.domain.verb.VerbDemoData;
import dittner.testmyself.deutsch.model.domain.verb.VerbHash;
import dittner.testmyself.deutsch.model.domain.verb.VerbSQLFactory;

public class ConfigureVerbModuleCmd implements IConfigureCommand {

	public function execute(verbModule:SFModule):void {
		//register models and services
		verbModule.registerProxy("model", createNoteModel());
		verbModule.registerProxy("testModel", createTestModel());
		verbModule.registerProxy("sqlFactory", new VerbSQLFactory());
		var spec:NoteServiceSpec = createSpec();
		verbModule.registerProxy("demoData", spec.demoData as SFProxy);
		verbModule.registerProxy("spec", spec);
		verbModule.registerProxy("service", new NoteService());
	}

	private function createNoteModel():NoteModel {
		var model:NoteModel = new NoteModel();
		model.noteHash = new VerbHash();
		return model;
	}

	private function createSpec():NoteServiceSpec {
		var spec:NoteServiceSpec = new NoteServiceSpec();
		spec.dbName = ModuleName.VERB;
		spec.noteClass = Verb;
		spec.demoData = new VerbDemoData();
		return spec;
	}

	private function createTestModel():TestModel {
		var model:TestModel = new TestModel();
		model.addTestInfo(new TestInfo(TestID.SPEAK_VERB_FORMS, ModuleName.VERB, "Название форм сильных глаголов"));
		return model;
	}
}
}