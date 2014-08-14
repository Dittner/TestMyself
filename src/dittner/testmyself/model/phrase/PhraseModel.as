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
	//  selectedPhrase
	//--------------------------------------
	private var _selectedPhrase:IPhrase = Phrase.NULL;
	public function get selectedPhrase():IPhrase {return _selectedPhrase;}
	public function set selectedPhrase(value:IPhrase):void {
		if (_selectedPhrase != value) {
			_selectedPhrase = value;
			sendMessage(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, selectedPhrase);
		}
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
	//  phrases
	//--------------------------------------
	private var _phrases:Array;
	public function get phrases():Array {return _phrases;}
	public function set phrases(value:Array):void {
		if (_phrases != value) {
			_phrases = value;
			sendMessage(PhraseMsg.PHRASES_CHANGED_NOTIFICATION, phrases);
		}
	}

	//--------------------------------------
	//  filter
	//--------------------------------------
	private var _filter:Vector.<Object> = new Vector.<Object>();
	public function get filter():Vector.<Object> {return _filter;}
	public function set filter(value:Vector.<Object>):void {
		if (_filter != value) {
			_filter = value;
			sendMessage(PhraseMsg.PHRASES_FILTER_CHANGED_NOTIFICATION, filter);
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
