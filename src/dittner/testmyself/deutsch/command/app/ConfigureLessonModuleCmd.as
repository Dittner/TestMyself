package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.SFModule;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.model.note.NoteModel;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.core.service.NoteServiceSpec;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.domain.common.TestID;
import dittner.testmyself.deutsch.model.domain.lesson.LessonDemoData;
import dittner.testmyself.deutsch.model.domain.lesson.LessonTestModel;

public class ConfigureLessonModuleCmd implements IConfigureCommand {

	public function execute(phraseModule:SFModule):void {
		//register models and services
		phraseModule.registerProxy("model", new NoteModel());
		phraseModule.registerProxy("testModel", createTestModel());
		phraseModule.registerProxy("sqlFactory", new SQLFactory());
		var spec:NoteServiceSpec = createSpec();
		phraseModule.registerProxy("demoData", spec.demoData as SFProxy);
		phraseModule.registerProxy("spec", spec);
		phraseModule.registerProxy("service", new NoteService());
	}

	private function createSpec():NoteServiceSpec {
		var spec:NoteServiceSpec = new NoteServiceSpec();
		spec.dbName = "lesson";
		spec.demoData = new LessonDemoData();
		return spec;
	}

	private function createTestModel():TestModel {
		var model:TestModel = new LessonTestModel();
		model.addTestInfo(new TestInfo(TestID.SPEAK_LESSON_TRANSLATION, ModuleName.LESSON, "Устный перевод с немецкого языка"));
		model.addTestInfo(new TestInfo(TestID.SPEAK_LESSON_IN_DEUTSCH, ModuleName.LESSON, "Устный перевод на немецкий язык"));
		model.addTestInfo(new TestInfo(TestID.WRITE_LESSON, ModuleName.LESSON, "Письменный перевод с немецкого языка"));
		return model;
	}
}
}