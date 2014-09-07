package dittner.testmyself.core.model.note {
import dittner.testmyself.core.model.page.IPageInfo;

public interface INoteModel {

	function get pageInfo():IPageInfo;
	function set pageInfo(value:IPageInfo):void;

	function get themes():Array;
	function set themes(value:Array):void;

	function get dataBaseInfo():NotesInfo;
	function set dataBaseInfo(value:NotesInfo):void;

	function get selectedNote():INote;
	function set selectedNote(value:INote):void;

	function get filter():Array;
	function set filter(value:Array):void;

}
}
