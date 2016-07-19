package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.common.TestID;
import de.dittner.testmyself.model.domain.note.NoteHash;
import de.dittner.testmyself.model.domain.note.NoteModel;
import de.dittner.testmyself.model.domain.note.verb.DeVerb;
import de.dittner.testmyself.model.domain.test.Test;

public class ConfigureVerbModuleCmd implements IConfigureCommand {

	public function execute(verbModule:SFModule):void {
		//register models and services
		verbModule.registerProxy("model", createNoteModel());
		verbModule.registerProxy("testModel", createTestModel());
		verbModule.registerProxy("sqlFactory", new VerbSQLFactory());
		var spec:NoteServiceSpec = createSpec();
		verbModule.registerProxy("spec", spec);
		verbModule.registerProxy("service", new SQLStorage());
	}

	private function createNoteModel():NoteModel {
		var model:NoteModel = new NoteModel();
		model.noteHash = new NoteHash();
		return model;
	}

	private function createSpec():NoteServiceSpec {
		var spec:NoteServiceSpec = new NoteServiceSpec();
		spec.dbName = ModuleName.VERB;
		spec.noteClass = DeVerb;
		return spec;
	}

	private function createTestModel():TestModel {
		var model:TestModel = new TestModel();
		model.addTestInfo(new Test(TestID.SPEAK_VERB_FORMS, ModuleName.VERB, "Deklination der starken Verben", true));
		model.addTestInfo(new Test(TestID.SPEAK_VERB_EXAMPLE_TRANSLATION, ModuleName.VERB, "Aus dem Deutschen die Beispiele übersetzen", false, true));
		model.addTestInfo(new Test(TestID.SPEAK_VERB_EXAMPLE_IN_DEUTSCH, ModuleName.VERB, "Ins Deutsche die Beispiele übersetzen", false, true));
		model.addTestInfo(new Test(TestID.WRITE_VERB_EXAMPLE, ModuleName.VERB, "Rechtschreibung der Beispiele", false, true));
		return model;
	}
}
}