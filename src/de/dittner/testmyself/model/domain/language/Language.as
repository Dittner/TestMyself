package de.dittner.testmyself.model.domain.language {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.utils.HashList;

import flash.events.Event;
import flash.events.EventDispatcher;

public class Language extends EventDispatcher {
	public function Language(id:uint, storage:SQLStorage) {
		this.storage = storage;
		_id = id;
	}

	protected var storage:SQLStorage;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:uint = 0;
	public function get id():uint {return _id;}

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String = "";
	[Bindable("titleChanged")]
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_title != value) {
			_title = value;
			dispatchEvent(new Event("titleChanged"));
		}
	}

	//--------------------------------------
	//  vocabularyHash
	//--------------------------------------
	private var _vocabularyHash:HashList = new HashList();
	public function get vocabularyHash():HashList {return _vocabularyHash;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function addVocabulary(v:Vocabulary):void {
		if (vocabularyHash.has(v.id)) throw new Error("Vocabulary " + v.title + " is already added");
		vocabularyHash.write(v.id, v);
	}

	public function init():IAsyncOperation {
		var op:IAsyncOperation;
		for each(var v:Vocabulary in vocabularyHash.getList())
			op = v.init();

		if (!op) {
			op = new AsyncOperation();
			op.dispatchSuccess();
		}
		return op;
	}
}
}
