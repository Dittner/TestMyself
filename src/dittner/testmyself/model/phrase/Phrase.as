package dittner.testmyself.model.phrase {
import dittner.testmyself.model.common.TransUnit;

public class Phrase extends TransUnit implements IPhrase {
	public static const NULL:IPhrase = new Phrase();

	public function Phrase():void {}
}
}
