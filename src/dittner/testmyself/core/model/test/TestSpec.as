package dittner.testmyself.core.model.test {
import dittner.testmyself.core.model.note.NoteFilter;

public class TestSpec {
	public var info:TestInfo;
	public var filter:NoteFilter = new NoteFilter();
	public var audioRecordRequired:Boolean = false;
	public var complexity:int = TestTaskComplexity.HIGH;
}
}
