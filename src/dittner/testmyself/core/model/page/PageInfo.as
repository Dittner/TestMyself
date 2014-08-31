package dittner.testmyself.core.model.page {
import dittner.testmyself.core.model.note.INote;

public class PageInfo implements IPageInfo {

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
	//  selectedNote
	//--------------------------------------
	private var _selectedNote:INote;
	public function get selectedNote():INote {return _selectedNote;}
	public function set selectedNote(value:INote):void {
		_selectedNote = value;
	}

	//--------------------------------------
	//  notes
	//--------------------------------------
	private var _notes:Array = [];
	public function get notes():Array {return _notes;}
	public function set notes(value:Array):void {
		_notes = value;
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
