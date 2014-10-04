package dittner.testmyself.core.model.note {
import dittner.testmyself.core.model.page.INotePageInfo;

public interface INoteModel {

	function get pageInfo():INotePageInfo;
	function set pageInfo(value:INotePageInfo):void;

	function get themes():Array;
	function set themes(value:Array):void;

	function get dataBaseInfo():NotesInfo;
	function set dataBaseInfo(value:NotesInfo):void;

	function get selectedNote():INote;
	function set selectedNote(value:INote):void;

	function get filter():NoteFilter;
	function set filter(value:NoteFilter):void;

	function get noteHash():NoteHash;
	function set noteHash(value:NoteHash):void;

}
}
