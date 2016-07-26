package de.dittner.testmyself.ui.view.test.testing.components {
import de.dittner.testmyself.model.domain.note.INote;

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

	function set complexity(value:uint):void;
	function get complexity():uint;

	function start():void;
	function stop():void;

}
}
