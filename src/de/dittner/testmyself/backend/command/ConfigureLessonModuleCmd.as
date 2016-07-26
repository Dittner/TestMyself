package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.test.Test;

public class ConfigureLessonModuleCmd implements IConfigureCommand {

	public function execute(lessonModule:SFModule):void {
		//register models and services
		lessonModule.registerProxy("model", new NoteModel());
		lessonModule.registerProxy("testModel", createTestModel());
		lessonModule.registerProxy("sqlFactory", new SQLLib());
		var spec:NoteServiceSpec = createSpec();
		lessonModule.registerProxy("spec", spec);
		lessonModule.registerProxy("service", new SQLStorage());
	}

	private function createSpec():NoteServiceSpec {
		var spec:NoteServiceSpec = new NoteServiceSpec();
		spec.dbName = ModuleName.LESSON;
		return spec;
	}

	private function createTestModel():TestModel {
		var model:TestModel = new LessonTestModel();
		model.addTestInfo(new Test(testID.SPEAK_LESSON_TRANSLATION, ModuleName.LESSON, "Aus dem Deutschen übersetzen"));
		model.addTestInfo(new Test(testID.SPEAK_LESSON_IN_DEUTSCH, ModuleName.LESSON, "Ins Deutsche übersetzen"));
		model.addTestInfo(new Test(testID.WRITE_LESSON, ModuleName.LESSON, "Rechtschreibung"));
		return model;
	}
}
}