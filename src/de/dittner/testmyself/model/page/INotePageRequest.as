package de.dittner.testmyself.model.page {
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.note.NoteFilter;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

public interface INotePageRequest {

	function get pageNum():uint;
	function get pageSize():uint;
	function get notes():Array;
	function get filter():NoteFilter;
	function get vocabulary():Vocabulary;

	function get selectedNote():INote;
	function set selectedNote(value:INote):void;
}
}
