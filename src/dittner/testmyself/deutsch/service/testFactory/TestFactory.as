package dittner.testmyself.deutsch.service.testFactory {
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.deutsch.model.domain.test.TestID;

public class TestFactory extends SFProxy implements ITestFactory {

	public function TestFactory():void {
		createTestInfos();
	}

	private var _testInfos:Array;
	public function get testInfos():Array {
		return _testInfos;
	}

	private function createTestInfos():void {
		_testInfos = [];
		var info:TestInfo;

		info = new TestInfo(TestID.SPEAK_WORD_TRANSLATION, "Устный перевод слов с немецкого языка");
		_testInfos.push(info);

		info = new TestInfo(TestID.SPEAK_PHRASE_TRANSLATION, "Устный перевод фраз и предложений с немецкого языка");
		_testInfos.push(info);

		info = new TestInfo(TestID.SPEAK_VERB_FORMS, "Название форм сильных глаголов");
		_testInfos.push(info);

		info = new TestInfo(TestID.WRITE_WORD_TRANSLATION, "Письменный перевод слов с немецкого языка");
		_testInfos.push(info);

		info = new TestInfo(TestID.WRITE_PHRASE_TRANSLATION, "Письменный перевод фраз и предложений с немецкого языка");
		_testInfos.push(info);

		info = new TestInfo(TestID.SELECT_ARTICLE, "Определение рода существительных");
		_testInfos.push(info);
	}

}
}
