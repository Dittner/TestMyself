package de.dittner.testmyself.model.domain.test {
import de.dittner.testmyself.model.domain.note.NoteFilter;

public class TestSpec {
	public var info:Test;
	public var filter:NoteFilter = new NoteFilter();
	public var audioRecordRequired:Boolean = false;
	public var complexity:int = TestTaskComplexity.HIGH;
}
}
