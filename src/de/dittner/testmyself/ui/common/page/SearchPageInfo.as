package de.dittner.testmyself.ui.common.page {
import de.dittner.testmyself.model.domain.language.Language;

public class SearchPageInfo implements IPageInfo {

	public function SearchPageInfo() {}

	public var lang:Language;
	public var searchText:String = "";
	public var vocabularyIDs:Array;
	public var loadExamples:Boolean;

	//--------------------------------------
	//  pageNum
	//--------------------------------------
	private var _pageNum:uint = 0;
	public function get pageNum():uint {return _pageNum;}
	public function set pageNum(value:uint):void {_pageNum = value;}

	//--------------------------------------
	//  pageSize
	//--------------------------------------
	private var _pageSize:uint = 10;
	public function get pageSize():uint {return _pageSize;}
	public function set pageSize(value:uint):void {_pageSize = value;}

	//--------------------------------------
	//  allNotesAmount
	//--------------------------------------
	private var _allNotesAmount:int;
	public function get allNotesAmount():int {return _allNotesAmount;}
	public function set allNotesAmount(value:int):void {_allNotesAmount = value;}

	//--------------------------------------
	//  notes
	//--------------------------------------
	private var _notes:Array = [];
	public function get notes():Array {return _notes;}
	public function set notes(value:Array):void {_notes = value;}

}
}
