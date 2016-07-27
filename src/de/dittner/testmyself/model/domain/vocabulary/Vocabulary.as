package de.dittner.testmyself.model.domain.vocabulary {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.domain_internal;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.utils.HashList;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

use namespace domain_internal;

public class Vocabulary extends EventDispatcher {
	public function Vocabulary(id:int, langID:uint, noteClass:Class, storage:SQLStorage, title:String) {
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
	private var _storage:SQLStorage;
	public function get storage():SQLStorage {return _storage;}

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

	domain_internal function addThemeToList(t:Theme):void {
		themeColl.addItem(t);
	}

	domain_internal function removeThemeFromList(t:Theme):void {
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
		for each(var title:String in op.result as Array)
			noteTitleHash.write(title, true);
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

	public function createNote():Note {
		var note:Note = new noteClass();
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
