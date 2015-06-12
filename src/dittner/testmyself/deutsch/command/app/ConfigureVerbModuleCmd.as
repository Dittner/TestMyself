package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.SFModule;
import dittner.testmyself.core.model.note.NoteHash;
import dittner.testmyself.core.model.note.NoteModel;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.core.service.NoteServiceSpec;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.domain.common.TestID;
import dittner.testmyself.deutsch.model.domain.verb.Verb;
import dittner.testmyself.deutsch.model.domain.verb.VerbSQLFactory;

public class ConfigureVerbModuleCmd implements IConfigureCommand {

	public function execute(verbModule:SFModule):void {
		//register models and services
		verbModule.registerProxy("model", createNoteModel());
		verbModule.registerProxy("testModel", createTestModel());
		verbModule.registerProxy("sqlFactory", new VerbSQLFactory());
		var spec:NoteServiceSpec = createSpec();
		verbModule.registerProxy("spec", spec);
		verbModule.registerProxy("service", new NoteService());
	}

	private function createNoteModel():NoteModel {
		var model:NoteModel = new NoteModel();
		model.noteHash = new NoteHash();
		return model;
	}

	private function createSpec():NoteServiceSpec {
		var spec:NoteServiceSpec = new NoteServiceSpec();
		spec.dbName = ModuleName.VERB;
		spec.noteClass = Verb;
		return spec;
	}

	private function createTestModel():TestModel {
		var model:TestModel = new TestModel();
		model.addTestInfo(new TestInfo(TestID.SPEAK_VERB_FORMS, ModuleName.VERB, "Deklination der starken Verben", true));
		model.addTestInfo(new TestInfo(TestID.SPEAK_VERB_EXAMPLE_IN_DEUTSCH, ModuleName.VERB, "Aus dem Deutschen übersetzen", false, true));
		model.addTestInfo(new TestInfo(TestID.SPEAK_VERB_EXAMPLE_TRANSLATION, ModuleName.VERB, "Aus dem Deutschen die Beispiele übersetzen", false, true));
		model.addTestInfo(new TestInfo(TestID.WRITE_VERB_EXAMPLE, ModuleName.VERB, "Rechtschreibung der Beispiele", false, true));
		return model;
	}
}
}