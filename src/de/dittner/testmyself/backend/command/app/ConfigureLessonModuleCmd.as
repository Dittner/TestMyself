package de.dittner.testmyself.backend.command.app {
import de.dittner.satelliteFlight.command.IConfigureCommand;
import de.dittner.satelliteFlight.module.SFModule;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.backend.NoteServiceSpec;
import de.dittner.testmyself.model.ModuleName;
import de.dittner.testmyself.model.domain.common.TestID;
import de.dittner.testmyself.model.domain.lesson.LessonTestModel;
import de.dittner.testmyself.model.domain.note.NoteModel;
import de.dittner.testmyself.model.domain.note.SQLFactory;
import de.dittner.testmyself.model.domain.test.TestInfo;
import de.dittner.testmyself.model.domain.test.TestModel;

public class ConfigureLessonModuleCmd implements IConfigureCommand {

	public function execute(lessonModule:SFModule):void {
		//register models and services
		lessonModule.registerProxy("model", new NoteModel());
		lessonModule.registerProxy("testModel", createTestModel());
		lessonModule.registerProxy("sqlFactory", new SQLFactory());
		var spec:NoteServiceSpec = createSpec();
		lessonModule.registerProxy("spec", spec);
		lessonModule.registerProxy("service", new NoteService());
	}

	private function createSpec():NoteServiceSpec {
		var spec:NoteServiceSpec = new NoteServiceSpec();
		spec.dbName = ModuleName.LESSON;
		return spec;
	}

	private function createTestModel():TestModel {
		var model:TestModel = new LessonTestModel();
		model.addTestInfo(new TestInfo(TestID.SPEAK_LESSON_TRANSLATION, ModuleName.LESSON, "Aus dem Deutschen übersetzen"));
		model.addTestInfo(new TestInfo(TestID.SPEAK_LESSON_IN_DEUTSCH, ModuleName.LESSON, "Ins Deutsche übersetzen"));
		model.addTestInfo(new TestInfo(TestID.WRITE_LESSON, ModuleName.LESSON, "Rechtschreibung"));
		return model;
	}
}
}