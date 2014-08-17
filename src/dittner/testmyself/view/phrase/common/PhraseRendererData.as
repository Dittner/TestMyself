package dittner.testmyself.view.phrase.common {
import dittner.testmyself.model.phrase.IPhrase;

public class PhraseRendererData {
	public function PhraseRendererData(phrase:IPhrase, layout:PageLayoutInfo) {
		_phrase = phrase;
		_layout = layout;
	}

	private var _phrase:IPhrase;
	public function get phrase():IPhrase {return _phrase;}

	private var _layout:PageLayoutInfo;
	public function get layout():PageLayoutInfo {return _layout;}

}
}
