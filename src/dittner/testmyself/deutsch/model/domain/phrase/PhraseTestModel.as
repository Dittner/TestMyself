package dittner.testmyself.deutsch.model.domain.phrase {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.deutsch.model.domain.common.TestID;

public class PhraseTestModel extends TestModel {
	public function PhraseTestModel() {
		super();
	}

	override public function validate(note:INote, testInfo:TestInfo):Boolean {
		if (testInfo.id == TestID.WRITE_PHRASE) return note.audioComment.bytes;
		return true;
	}
}
}
