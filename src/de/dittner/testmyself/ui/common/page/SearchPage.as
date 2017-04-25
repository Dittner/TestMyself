package de.dittner.testmyself.ui.common.page {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.language.Language;

import flash.events.Event;

public class SearchPage extends NotePage {

	public function SearchPage() {}

	public var lang:Language;

	//--------------------------------------
	//  loadExamples
	//--------------------------------------
	private var _loadExamples:Boolean = true;
	[Bindable("loadExamplesChanged")]
	public function get loadExamples():Boolean {return _loadExamples;}
	public function set loadExamples(value:Boolean):void {
		if (_loadExamples != value) {
			_loadExamples = value;
			dispatchEvent(new Event("loadExamplesChanged"));
		}
	}

	//--------------------------------------
	//  vocabularyIDs
	//--------------------------------------
	private var _vocabularyIDs:Array = [];
	[Bindable("vocabularyIDsChanged")]
	public function get vocabularyIDs():Array {return _vocabularyIDs;}
	public function set vocabularyIDs(value:Array):void {
		if (_vocabularyIDs != value) {
			_vocabularyIDs = value;
			dispatchEvent(new Event("vocabularyIDsChanged"));
		}
	}

	//--------------------------------------
	//  searchText
	//--------------------------------------
	private var _searchText:String = "";
	[Bindable("searchTextChanged")]
	public function get searchText():String {return _searchText;}
	public function set searchText(value:String):void {
		if (_searchText != value) {
			_searchText = value;
			dispatchEvent(new Event("searchTextChanged"));
		}
	}

	override public function load():IAsyncOperation {
		return storage.searchNotes(this);
	}

}
}
