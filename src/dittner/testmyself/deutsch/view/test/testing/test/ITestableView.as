package dittner.testmyself.deutsch.view.test.testing.test {
import dittner.testmyself.core.model.note.INote;

import mx.collections.ArrayCollection;

public interface ITestableView {
	function set actionCallback(value:Function):void;
	function get actionCallback():Function;

	function set answerEnabled(value:Boolean):void;
	function get answerEnabled():Boolean;

	function set taskNumber(value:int):void;
	function get taskNumber():int;

	function set totalTask(value:int):void;
	function get totalTask():int;

	function set activeNote(value:INote):void;
	function get activeNote():INote;

	function set activeNoteExampleColl(value:ArrayCollection):void;
	function get activeNoteExampleColl():ArrayCollection;

	function start():void;
	function stop():void;

}
}
