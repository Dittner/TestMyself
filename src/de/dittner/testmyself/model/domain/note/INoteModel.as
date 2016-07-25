package de.dittner.testmyself.model.domain.note {
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;
import de.dittner.testmyself.model.page.INotePageRequest;

public interface INoteModel {

	function get pageInfo():INotePageRequest;
	function set pageInfo(value:INotePageRequest):void;

	function get themes():Array;
	function set themes(value:Array):void;

	function get dataBaseInfo():VocabularyInfo;
	function set dataBaseInfo(value:VocabularyInfo):void;

	function get selectedNote():INote;
	function set selectedNote(value:INote):void;

	function get filter():NoteFilter;
	function set filter(value:NoteFilter):void;

	function get noteHash():NoteHash;
	function set noteHash(value:NoteHash):void;

}
}
