package de.dittner.testmyself.model.domain.vocabulary {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.utils.HashList;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

public class Vocabulary extends EventDispatcher {
	public function Vocabulary(id:int, lang:Language, noteClass:Class, storage:Storage, title:String) {
		super();
		_id = id;
		_lang = lang;
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
	//  lang
	//--------------------------------------
	private var _lang:Language;
	public function get lang():Language {return _lang;}

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
	//  tags
	//--------------------------------------
	private var _tagColl:ArrayCollection = new ArrayCollection();
	[Bindable("tagCollChanged")]
	public function get tagColl():ArrayCollection {return _tagColl;}
	private function setTagColl(value:ArrayCollection):void {
		if (_tagColl != value) {
			_tagColl = value;
			_tagHash = {};
			for each(var tag:Tag in value) {
				_tagHash[tag.id] = tag;
				_tagNameHash[tag.name] = tag;
			}

			dispatchEvent(new Event("tagCollChanged"));
		}
	}

	//--------------------------------------
	//  tagHash
	//--------------------------------------
	private var _tagHash:Object = {};
	[Bindable("tagCollChanged")]
	public function get tagHash():Object {return _tagHash;}

	//--------------------------------------
	//  tagNameHash
	//--------------------------------------
	private var _tagNameHash:Object = {};
	[Bindable("tagCollChanged")]
	public function get tagNameHash():Object {return _tagNameHash;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function init():IAsyncOperation {
		reloadNotesTitles();
		return reloadTags();
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

	private function reloadTags():IAsyncOperation {
		var op:IAsyncOperation = storage.loadAllTags(this);
		op.addCompleteCallback(allTagsLoaded);
		return op;
	}

	private function allTagsLoaded(op:IAsyncOperation):void {
		setTagColl(new ArrayCollection(op.result));
	}

	public function loadInfo():IAsyncOperation {
		return storage.loadVocabularyInfo(this);
	}

	public function createNote(noteData:Object = null):Note {
		var note:Note = noteData && noteData.isExample ? Note.createExample(this, noteData.parentID) : new noteClass();
		note.vocabulary = this;
		return note;
	}

	public function createTag():Tag {
		var tag:Tag = new Tag();
		tag.vocabulary = this;
		return tag;
	}

	public function addTag(t:Tag):void {
		if (!tagHash[t.id]) {
			tagHash[t.id] = t;
			tagNameHash[t.name] = t;
			tagColl.addItem(t);
		}
	}

	public function removeTag(t:Tag):void {
		if (tagHash[t.id]) {
			delete tagHash[t.id];
			delete tagNameHash[t.name];
			tagColl.removeItem(t);
		}
	}

}
}
