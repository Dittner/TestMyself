package de.dittner.testmyself.model.domain.lesson {
import de.dittner.testmyself.model.domain.common.TestID;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.test.TestInfo;
import de.dittner.testmyself.model.domain.test.TestModel;

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
