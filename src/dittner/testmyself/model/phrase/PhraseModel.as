package dittner.testmyself.model.phrase {
import dittner.testmyself.message.PhraseMsg;

import mvcexpress.mvc.Proxy;

public class PhraseModel extends Proxy {

	public function PhraseModel():void {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  pageInfo
	//--------------------------------------
	private var _pageInfo:PhrasePageInfo = null;
	public function get pageInfo():PhrasePageInfo {return _pageInfo;}
	public function set pageInfo(value:PhrasePageInfo):void {
		_pageInfo = value;
		sendMessage(PhraseMsg.PAGE_INFO_CHANGED_NOTIFICATION, pageInfo);
	}

	//--------------------------------------
	//  themes
	//--------------------------------------
	private var _themes:Array;
	public function get themes():Array {return _themes;}
	public function set themes(value:Array):void {
		if (_themes != value) {
			_themes = value;
			sendMessage(PhraseMsg.THEMES_CHANGED_NOTIFICATION, themes);
		}
	}

	//--------------------------------------
	//  selectedPhrase
	//--------------------------------------
	public function get selectedPhrase():IPhrase {return pageInfo ? pageInfo.selectedPhrase : Phrase.NULL;}
	public function set selectedPhrase(value:IPhrase):void {
		if (pageInfo && pageInfo.selectedPhrase != value) {
			pageInfo.selectedPhrase = value;
			sendMessage(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, selectedPhrase);
		}
	}

	//--------------------------------------
	//  filter
	//--------------------------------------
	private var _filter:Array = [];
	public function get filter():Array {return _filter;}
	public function set filter(value:Array):void {
		if (_filter != value) {
			_filter = value;
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function onRegister():void {}
	override protected function onRemove():void {}

}
}
