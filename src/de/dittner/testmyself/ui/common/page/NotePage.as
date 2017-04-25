package de.dittner.testmyself.ui.common.page {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.walter.Walter;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

[Event(name="noteChanged", type="flash.events.Event")]
public class NotePage extends EventDispatcher {
	public static const NOTE_CHANGED:String = "noteChanged";

	public function NotePage() {}

	//--------------------------------------
	//  number
	//--------------------------------------
	private var _number:uint = 0;
	[Bindable("numberChanged")]
	public function get number():uint {return _number;}
	public function set number(value:uint):void {
		if (_number != value) {
			_number = value;
			dispatchEvent(new Event("numberChanged"));
		}
	}

	//--------------------------------------
	//  size
	//--------------------------------------
	private var _size:uint = 10;
	[Bindable("sizeChanged")]
	public function get size():uint {return _size;}
	public function set size(value:uint):void {
		if (_size != value) {
			_size = value;
			setTotalPages(Math.ceil(allNotesAmount / size));
			dispatchEvent(new Event("sizeChanged"));
		}
	}

	//--------------------------------------
	//  allNotesAmount
	//--------------------------------------
	private var _allNotesAmount:int = 0;
	[Bindable("allNotesAmountChanged")]
	public function get allNotesAmount():int {return _allNotesAmount;}
	public function set allNotesAmount(value:int):void {
		if (_allNotesAmount != value) {
			_allNotesAmount = value;
			setTotalPages(Math.ceil(allNotesAmount / size));
			dispatchEvent(new Event("allNotesAmountChanged"));
		}
	}

	//--------------------------------------
	//  totalPages
	//--------------------------------------
	private var _totalPages:int;
	[Bindable("totalPagesChanged")]
	public function get totalPages():int {return _totalPages;}
	private function setTotalPages(value:int):void {
		if (_totalPages != value) {
			_totalPages = value;
			dispatchEvent(new Event("totalPagesChanged"));
		}
	}

	//--------------------------------------
	//  countAllNotes
	//--------------------------------------
	private var _countAllNotes:Boolean = true;
	[Bindable("countAllNotesChanged")]
	public function get countAllNotes():Boolean {return _countAllNotes;}
	public function set countAllNotes(value:Boolean):void {
		if (_countAllNotes != value) {
			_countAllNotes = value;
			dispatchEvent(new Event("countAllNotesChanged"));
		}
	}

	//--------------------------------------
	//  vocabulary
	//--------------------------------------
	private var _vocabulary:Vocabulary;
	[Bindable("vocabularyChanged")]
	public function get vocabulary():Vocabulary {return _vocabulary;}
	public function set vocabulary(value:Vocabulary):void {
		if (_vocabulary != value) {
			_vocabulary = value;
			dispatchEvent(new Event("vocabularyChanged"));
		}
	}

	//--------------------------------------
	//  coll
	//--------------------------------------
	private var _coll:ArrayCollection = new ArrayCollection();
	[Bindable("collChanged")]
	public function get coll():ArrayCollection {return _coll;}
	public function set coll(value:ArrayCollection):void {
		if (_coll != value) {
			_coll = value;
			dispatchEvent(new Event("collChanged"));
		}
	}

	//--------------------------------------
	//  selectedTag
	//--------------------------------------
	private var _selectedTag:Tag;
	[Bindable("selectedTagChanged")]
	public function get selectedTag():Tag {return _selectedTag;}
	public function set selectedTag(value:Tag):void {
		if (_selectedTag != value) {
			_selectedTag = value;
			dispatchEvent(new Event("selectedTagChanged"));
		}
	}

	//--------------------------------------
	//  selectedNote
	//--------------------------------------
	[Bindable("noteChanged")]
	public function get selectedNote():Note {return getNote();}

	//--------------------------------------
	//  selectedItemIndex
	//--------------------------------------
	private var _selectedItemIndex:int = 0;
	[Bindable("selectedItemIndexChanged")]
	public function get selectedItemIndex():int {return _selectedItemIndex;}
	public function set selectedItemIndex(value:int):void {
		if (_selectedItemIndex != value) {
			_selectedItemIndex = value;
			dispatchEvent(new Event("selectedItemIndexChanged"));
			dispatchEvent(new Event("noteChanged"));
		}
	}

	protected function getNote():Note {
		return coll && coll.length > 0 && coll.length > selectedItemIndex ? coll[selectedItemIndex] : null;
	}

	protected function get storage():Storage {
		return Walter.instance.getProxy("storage") as Storage;
	}

	public function load():IAsyncOperation {
		return storage.loadNotePage(this);
	}

}
}
