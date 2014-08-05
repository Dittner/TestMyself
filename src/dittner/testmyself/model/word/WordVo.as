package dittner.testmyself.model.word {
import dittner.testmyself.model.common.LanguageUnitVo;

public class WordVo extends LanguageUnitVo {
	public static const NULL:WordVo = new WordVo();

	public function WordVo():void {}

	public var aricle:String = "";
	public var multiple:String = "";
}
}
