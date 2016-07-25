package de.dittner.testmyself.model.page {
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

public class NotePageInfo implements INotePageRequest {

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
	//  allNotesAmount
	//--------------------------------------
	private var _allNotesAmount:int;
	public function get allNotesAmount():int {return _allNotesAmount;}
	public function set allNotesAmount(value:int):void {_allNotesAmount = value;}

	//--------------------------------------
	//  vocabulary
	//--------------------------------------
	private var _vocabulary:Vocabulary;
	public function get vocabulary():Vocabulary {return _vocabulary;}
	public function set vocabulary(value:Vocabulary):void {_vocabulary = value;}

	//--------------------------------------
	//  selectedNote
	//--------------------------------------
	private var _selectedNote:INote;
	public function get selectedNote():INote {return _selectedNote;}
	public function set selectedNote(value:INote):void {_selectedNote = value;}

	//--------------------------------------
	//  notes
	//--------------------------------------
	private var _notes:Array = [];
	public function get notes():Array {return _notes;}
	public function set notes(value:Array):void {_notes = value;}

	//--------------------------------------
	//  selectedTheme
	//--------------------------------------
	private var _selectedTheme:Theme;
	public function get selectedTheme():Theme {return _selectedTheme;}
	public function set selectedTheme(value:Theme):void {_selectedTheme = value;}

}
}
