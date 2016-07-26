package de.dittner.testmyself.ui.common.page {
public interface IPageInfo {
	function get pageNum():uint;
	function get pageSize():uint;
	function get allNotesAmount():int
	function set allNotesAmount(value:int):void;
	function get notes():Array;
	function set notes(value:Array):void;
}
}
