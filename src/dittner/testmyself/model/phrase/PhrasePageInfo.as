package dittner.testmyself.model.phrase {
public class PhrasePageInfo implements IPhrasePageInfo {

	//--------------------------------------
	//  pageNum
	//--------------------------------------
	private var _pageNum:uint = 0;
	public function get pageNum():uint {return _pageNum;}
	public function set pageNum(value:uint):void {
		_pageNum = value;
	}

	//--------------------------------------
	//  pageSize
	//--------------------------------------
	private var _pageSize:uint = 10;
	public function get pageSize():uint {return _pageSize;}
	public function set pageSize(value:uint):void {
		_pageSize = value;
	}

	//--------------------------------------
	//  selectedPhrase
	//--------------------------------------
	private var _selectedPhrase:IPhrase = Phrase.NULL;
	public function get selectedPhrase():IPhrase {return _selectedPhrase;}
	public function set selectedPhrase(value:IPhrase):void {
		_selectedPhrase = value;
	}

	//--------------------------------------
	//  phrases
	//--------------------------------------
	private var _phrases:Array = [];
	public function get phrases():Array {return _phrases;}
	public function set phrases(value:Array):void {
		_phrases = value;
	}

	//--------------------------------------
	//  filter
	//--------------------------------------
	private var _filter:Array = [];
	public function get filter():Array {return _filter;}
	public function set filter(value:Array):void {
		_filter = value;
	}

}
}
