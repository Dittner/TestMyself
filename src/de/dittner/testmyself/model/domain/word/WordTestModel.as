package de.dittner.testmyself.model.domain.word {
import de.dittner.testmyself.model.domain.common.TestID;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.test.TestInfo;
import de.dittner.testmyself.model.domain.test.TestModel;

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
