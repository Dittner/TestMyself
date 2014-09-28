package dittner.testmyself.deutsch.command.app {
import dittner.satelliteFlight.command.IConfigureCommand;
import dittner.satelliteFlight.module.SFModule;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.model.note.NoteModel;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.core.service.NoteServiceSpec;
import dittner.testmyself.deutsch.model.domain.lesson.LessonDemoData;

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
		var model:TestModel = new TestModel();
		return model;
	}
}
}