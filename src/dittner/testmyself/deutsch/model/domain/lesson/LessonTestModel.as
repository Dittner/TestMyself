package dittner.testmyself.deutsch.model.domain.lesson {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.deutsch.model.domain.common.TestID;

public class LessonTestModel extends TestModel {
	public function LessonTestModel() {
		super();
	}

	override public function validate(note:INote, testInfo:TestInfo):Boolean {
		if (testInfo.id == TestID.WRITE_LESSON) return note.audioComment.bytes;
		return true;
	}
}
}
