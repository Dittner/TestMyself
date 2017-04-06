package de.dittner.testmyself.ui.view.test.testing.components {
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.ui.common.page.INotePage;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

public class TestPage extends EventDispatcher implements INotePage{
	public function TestPage() {
		super();
	}

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
			dispatchEvent(new Event("allNotesAmountChanged"));
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
	//  loadOnlyFailedTestTask
	//--------------------------------------
	private var _loadOnlyFailedTestTask:Boolean = false;
	[Bindable("loadOnlyFailedTestTaskChanged")]
	public function get loadOnlyFailedTestTask():Boolean {return _loadOnlyFailedTestTask;}
	public function set loadOnlyFailedTestTask(value:Boolean):void {
		if (_loadOnlyFailedTestTask != value) {
			_loadOnlyFailedTestTask = value;
			dispatchEvent(new Event("loadOnlyFailedTestTaskChanged"));
		}
	}

	//--------------------------------------
	//  coll
	//--------------------------------------
	public var tasks:Array;
	private var _coll:ArrayCollection;
	[Bindable("collChanged")]
	public function get coll():ArrayCollection {return _coll;}
	public function set coll(value:ArrayCollection):void {
		if (_coll != value) {
			_coll = value;
			dispatchEvent(new Event("collChanged"));
		}
	}

	//--------------------------------------
	//  test
	//--------------------------------------
	private var _test:Test;
	[Bindable("testChanged")]
	public function get test():Test {return _test;}
	public function set test(value:Test):void {
		if (_test != value) {
			_test = value;
			dispatchEvent(new Event("testChanged"));
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

}
}
