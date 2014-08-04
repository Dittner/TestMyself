package dittner.testmyself.model.phrase {
import dittner.testmyself.message.PhraseMsg;

import mvcexpress.mvc.Proxy;

public class PhraseModel extends Proxy {

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function PhraseModel():void {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  selectedPhrase
	//--------------------------------------
	private var _selectedPhrase:PhraseVo;
	public function get selectedPhrase():PhraseVo {return _selectedPhrase;}
	public function set selectedPhrase(value:PhraseVo):void {
		if (_selectedPhrase != value) {
			_selectedPhrase = value;
			sendMessage(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, selectedPhrase);
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function clear():void {
		_selectedPhrase = PhraseVo.NULL;
	}

	override protected function onRegister():void {
		clear();
	}
	override protected function onRemove():void {
		trace("PhraseModel onRemove");
	}

}
}
