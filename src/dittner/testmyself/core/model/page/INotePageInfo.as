package dittner.testmyself.core.model.page {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.note.NoteFilter;

public interface INotePageInfo {

	function get pageNum():uint;
	function get pageSize():uint;
	function get notes():Array;
	function get filter():NoteFilter;

	function get selectedNote():INote;
	function set selectedNote(value:INote):void;
}
}
