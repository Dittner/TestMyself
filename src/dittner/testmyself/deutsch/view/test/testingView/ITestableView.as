package dittner.testmyself.deutsch.view.test.testingView {
import dittner.testmyself.core.model.note.INote;

import mx.collections.ArrayCollection;

public interface ITestableView {

	function get actionCallback():Function;
	function set actionCallback(value:Function):void;

	function get audioRecordRequired():Boolean;
	function get isBalancePriority():Boolean;

	function set title(value:String):void;

	function get taskNumber():int;
	function set taskNumber(value:int):void;

	function get totalTask():int;
	function set totalTask(value:int):void;

	function set availableThemes(value:ArrayCollection):void;
	function get availableThemes():ArrayCollection;

	function set activeNoteExampleColl(value:ArrayCollection):void;
	function get activeNoteExampleColl():ArrayCollection;

	function get selectedThemes():Vector.<Object>;

	function get activeNote():INote;
	function set activeNote(value:INote):void;

	function get answerEnabled():Boolean;
	function set answerEnabled(value:Boolean):void;

	function abort():void;

}
}
