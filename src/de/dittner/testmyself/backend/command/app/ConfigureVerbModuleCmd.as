package de.dittner.testmyself.backend.command.app {
import de.dittner.satelliteFlight.command.IConfigureCommand;
import de.dittner.satelliteFlight.module.SFModule;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.backend.NoteServiceSpec;
import de.dittner.testmyself.model.ModuleName;
import de.dittner.testmyself.model.domain.common.TestID;
import de.dittner.testmyself.model.domain.note.NoteHash;
import de.dittner.testmyself.model.domain.note.NoteModel;
import de.dittner.testmyself.model.domain.test.TestInfo;
import de.dittner.testmyself.model.domain.test.TestModel;
import de.dittner.testmyself.model.domain.verb.Verb;
import de.dittner.testmyself.model.domain.verb.VerbSQLFactory;

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
		model.addTestInfo(new TestInfo(TestID.SPEAK_VERB_EXAMPLE_TRANSLATION, ModuleName.VERB, "Aus dem Deutschen die Beispiele übersetzen", false, true));
		model.addTestInfo(new TestInfo(TestID.SPEAK_VERB_EXAMPLE_IN_DEUTSCH, ModuleName.VERB, "Ins Deutsche die Beispiele übersetzen", false, true));
		model.addTestInfo(new TestInfo(TestID.WRITE_VERB_EXAMPLE, ModuleName.VERB, "Rechtschreibung der Beispiele", false, true));
		return model;
	}
}
}