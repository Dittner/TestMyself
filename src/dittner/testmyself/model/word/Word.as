package dittner.testmyself.model.word {
import dittner.testmyself.model.common.TransUnit;

public class Word extends TransUnit {
	public static const NULL:Word = new Word();

	public function Word():void {}

	public var aricle:String = "";
	public var multiple:String = "";
}
}
