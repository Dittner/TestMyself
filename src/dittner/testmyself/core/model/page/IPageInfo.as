package dittner.testmyself.core.model.page {
import dittner.testmyself.core.model.note.INote;

public interface IPageInfo {

	function get pageNum():uint;
	function get pageSize():uint;
	function get notes():Array;
	function get filter():Array;

	function get selectedNote():INote;
	function set selectedNote(value:INote):void;
}
}
