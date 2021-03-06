package dittner.testmyself.deutsch.model.domain.word {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.deutsch.model.domain.common.TestID;

public class WordTestModel extends TestModel {
	public function WordTestModel() {
		super();
	}

	override public function validate(note:INote, testInfo:TestInfo):Boolean {
		if (testInfo.id == TestID.SELECT_ARTICLE) return (note as Word).article;
		else if (testInfo.id == TestID.WRITE_WORD) return note.audioComment.bytes;
		return true;
	}
}
}
