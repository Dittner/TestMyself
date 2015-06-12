package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.SFModule;
import dittner.testmyself.core.model.note.NoteModel;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.core.service.NoteServiceSpec;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.domain.common.TestID;
import dittner.testmyself.deutsch.model.domain.word.Word;
import dittner.testmyself.deutsch.model.domain.word.WordHash;
import dittner.testmyself.deutsch.model.domain.word.WordSQLFactory;
import dittner.testmyself.deutsch.model.domain.word.WordTestModel;

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
		model.noteHash = new WordHash();
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
		model.addTestInfo(new TestInfo(TestID.SPEAK_WORD_EXAMPLE_IN_DEUTSCH, ModuleName.WORD, "Aus dem Deutschen die Beispiele übersetzen", false, true));
		model.addTestInfo(new TestInfo(TestID.SPEAK_WORD_EXAMPLE_TRANSLATION, ModuleName.WORD, "Ins Deutsche die Beispiele übersetzen", false, true));
		model.addTestInfo(new TestInfo(TestID.WRITE_WORD_EXAMPLE, ModuleName.WORD, "Rechtschreibung der Beispiele", false, true));
		return model;
	}
}
}