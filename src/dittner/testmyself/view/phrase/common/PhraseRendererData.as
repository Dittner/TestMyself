package dittner.testmyself.view.phrase.common {
import dittner.testmyself.model.phrase.PhraseVo;
import dittner.testmyself.view.common.mediator.mediator_internal;

use namespace mediator_internal;

public class PhraseRendererData {
	public function PhraseRendererData(phrase:PhraseVo) {
		_phrase = phrase;
	}

	public var dataChangedCallback:Function;

	//--------------------------------------
	//  phrase
	//--------------------------------------
	private var _phrase:PhraseVo;
	mediator_internal function get phrase():PhraseVo {return _phrase;}

	//--------------------------------------
	//  origin
	//--------------------------------------
	public function get origin():String {return _phrase.content.origin;}

	//--------------------------------------
	//  translation
	//--------------------------------------
	public function get translation():String {return _phrase.content.translation;}

	//--------------------------------------
	//  horizontalLayout
	//--------------------------------------
	private var _horizontalLayout:Boolean = false;
	public function get horizontalLayout():Boolean {return _horizontalLayout;}
	public function set horizontalLayout(value:Boolean):void {
		if (_horizontalLayout != value) {
			_horizontalLayout = value;
			if (dataChangedCallback != null) dataChangedCallback();
		}
	}

	//--------------------------------------
	//  showDetails
	//--------------------------------------
	private var _showDetails:Boolean = false;
	public function get showDetails():Boolean {return _showDetails;}
	public function set showDetails(value:Boolean):void {
		if (_showDetails != value) {
			_showDetails = value;
			if (dataChangedCallback != null) dataChangedCallback();
		}
	}

	//--------------------------------------
	//  transReverted
	//--------------------------------------
	private var _transInverted:Boolean = false;
	public function get transInverted():Boolean {return _transInverted;}
	public function set transInverted(value:Boolean):void {
		if (_transInverted != value) {
			_transInverted = value;
			if (dataChangedCallback != null) dataChangedCallback();
		}
	}
}
}
