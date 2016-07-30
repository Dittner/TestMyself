package de.dittner.testmyself.model.domain.vocabulary {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.utils.HashList;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

public class Vocabulary extends EventDispatcher {
	public function Vocabulary(id:int, langID:uint, noteClass:Class, storage:Storage, title:String) {
		super();
		_id = id;
		_langID = langID;
		_noteClass = noteClass;
		_storage = storage;
		_title = title;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:int = -1;
	public function get id():int {return _id;}

	//--------------------------------------
	//  langID
	//--------------------------------------
	private var _langID:uint = 0;
	public function get langID():uint {return _langID;}

	//--------------------------------------
	//  noteClass
	//--------------------------------------
	private var _noteClass:Class;
	public function get noteClass():Class {return _noteClass;}

	//--------------------------------------
	//  storage
	//--------------------------------------
	private var _storage:Storage;
	public function get storage():Storage {return _storage;}

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String = "";
	public function get title():String {return _title;}

	//--------------------------------------
	//  availableTests
	//--------------------------------------
	private var _availableTests:Array = [];
	public function get availableTests():Array {return _availableTests;}
	public function addTest(info:Test):void {
		_availableTests.push(info);
	}

	//--------------------------------------
	//  noteTitleHash
	//--------------------------------------
	private var _noteTitleHash:HashList = new HashList();
	public function get noteTitleHash():HashList {return _noteTitleHash;}

	//--------------------------------------
	//  themes
	//--------------------------------------
	private var _themeColl:ArrayCollection = new ArrayCollection();
	[Bindable("themeCollChanged")]
	public function get themeColl():ArrayCollection {return _themeColl;}
	private function setThemeColl(value:ArrayCollection):void {
		if (_themeColl != value) {
			_themeColl = value;
			dispatchEvent(new Event("themeCollChanged"));
		}
	}

	public function addTheme(t:Theme):void {
		if (t.id == -1) return;
		var hasTheme:Boolean = false;
		for each(var theme:Theme in themeColl)
			if (theme.id == t.id) {
				hasTheme = true;
				break;
			}

		if (!hasTheme) themeColl.addItem(t);
	}

	public function removeTheme(t:Theme):void {
		themeColl.removeItem(t);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function init():IAsyncOperation {
		reloadNotesTitles();
		return reloadThemes();
	}

	private function reloadNotesTitles():IAsyncOperation {
		var op:IAsyncOperation = storage.loadAllNotesTitles(this);
		op.addCompleteCallback(notesTitlesLoaded);
		return op;
	}

	private function notesTitlesLoaded(op:IAsyncOperation):void {
		noteTitleHash.clearAll();
		for each(var data:Object in op.result as Array)
			noteTitleHash.write(data.title, true);
	}

	private function reloadThemes():IAsyncOperation {
		var op:IAsyncOperation = storage.loadAllThemes(this);
		op.addCompleteCallback(allThemesLoaded);
		return op;
	}

	private function allThemesLoaded(op:IAsyncOperation):void {
		setThemeColl(new ArrayCollection(op.result));
	}

	public function loadInfo():IAsyncOperation {
		return storage.loadVocabularyInfo(this);
	}

	public function createNote(noteData:Object = null):Note {
		var note:Note = noteData && noteData.isExample ? Note.createExample(this, noteData.parentID) : new noteClass();
		note.vocabulary = this;
		return note;
	}

	public function createTheme():Theme {
		var theme:Theme = new Theme();
		theme.vocabulary = this;
		return theme;
	}

}
}
