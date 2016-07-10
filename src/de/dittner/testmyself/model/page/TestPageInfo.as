package de.dittner.testmyself.model.page {
import de.dittner.testmyself.model.domain.test.TestSpec;

public class TestPageInfo implements ITestPageInfo {

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
	//  onlyFailedNotes
	//--------------------------------------
	private var _onlyFailedNotes:Boolean = false;
	public function get onlyFailedNotes():Boolean {return _onlyFailedNotes;}
	public function set onlyFailedNotes(value:Boolean):void {
		_onlyFailedNotes = value;
	}

	//--------------------------------------
	//  tasks
	//--------------------------------------
	private var _tasks:Array = [];
	public function get tasks():Array {return _tasks;}
	public function set tasks(value:Array):void {
		_tasks = value;
	}

	//--------------------------------------
	//  notes
	//--------------------------------------
	private var _notes:Array;
	public function get notes():Array {return _notes;}
	public function set notes(value:Array):void {
		_notes = value;
	}

	//--------------------------------------
	//  testSpec
	//--------------------------------------
	private var _testSpec:TestSpec;
	public function get testSpec():TestSpec {return _testSpec;}
	public function set testSpec(value:TestSpec):void {
		_testSpec = value;
	}

}
}
