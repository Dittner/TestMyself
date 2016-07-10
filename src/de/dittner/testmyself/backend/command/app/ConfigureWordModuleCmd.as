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
import de.dittner.testmyself.model.domain.word.Word;
import de.dittner.testmyself.model.domain.word.WordSQLFactory;
import de.dittner.testmyself.model.domain.word.WordTestModel;

public class ConfigureWordModuleCmd implements IConfigureCommand {

	public function execute(wordModule:SFModule):void {
		//register models and services
		wordModule.registerProxy("model", createNoteModel());
		wordModule.registerProxy("testModel", createTestModel());
		wordModule.registerProxy("sqlFactory", new WordSQLFactory());
		var spec:NoteServiceSpec = createSpec();
		wordModule.registerProxy("spec", spec);
		wordModule.registerProxy("service", new NoteService());
	}

	private function createNoteModel():NoteModel {
		var model:NoteModel = new NoteModel();
		model.noteHash = new NoteHash();
		return model;
	}

	private function createSpec():NoteServiceSpec {
		var spec:NoteServiceSpec = new NoteServiceSpec();
		spec.dbName = ModuleName.WORD;
		spec.noteClass = Word;
		return spec;
	}

	private function createTestModel():TestModel {
		var model:TestModel = new WordTestModel();
		model.addTestInfo(new TestInfo(TestID.SPEAK_WORD_TRANSLATION, ModuleName.WORD, "Aus dem Deutschen übersetzen", true));
		model.addTestInfo(new TestInfo(TestID.SPEAK_WORD_IN_DEUTSCH, ModuleName.WORD, "Ins Deutsche übersetzen"));
		model.addTestInfo(new TestInfo(TestID.WRITE_WORD, ModuleName.WORD, "Rechtschreibung"));
		model.addTestInfo(new TestInfo(TestID.SELECT_ARTICLE, ModuleName.WORD, "Artikel auswählen"));
		model.addTestInfo(new TestInfo(TestID.SPEAK_WORD_EXAMPLE_TRANSLATION, ModuleName.WORD, "Aus dem Deutschen die Beispiele übersetzen", false, true));
		model.addTestInfo(new TestInfo(TestID.SPEAK_WORD_EXAMPLE_IN_DEUTSCH, ModuleName.WORD, "Ins Deutsche die Beispiele übersetzen", false, true));
		model.addTestInfo(new TestInfo(TestID.WRITE_WORD_EXAMPLE, ModuleName.WORD, "Rechtschreibung der Beispiele", false, true));
		return model;
	}
}
}