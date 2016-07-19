package de.dittner.testmyself.model.domain.vocabulary {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.Test;

import flash.events.Event;
import flash.events.EventDispatcher;

public class Vocabulary extends EventDispatcher {
	public function Vocabulary(id:int, noteClass:Class) {
		super();
		_id = id;
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
	//  noteClass
	//--------------------------------------
	private var _noteClass:Class;
	public function get noteClass():Class {return _noteClass;}

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
	//  availableTests
	//--------------------------------------
	private var _availableTests:Array = [];
	public function get availableTests():Array {return _availableTests;}
	public function addTest(info:Test):void {
		_availableTests.push(info);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function createNote():Note {
		var note:Note = new noteClass();
		note.vocabulary = this;
		return note;
	}

}
}
