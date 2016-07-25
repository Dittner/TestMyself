package de.dittner.testmyself.model.page {
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

public interface INotePageRequest {

	function get pageNum():uint;
	function get pageSize():uint;
	function get allNotesAmount():int
	function get notes():Array;
	function get selectedTheme():Theme;
	function get vocabulary():Vocabulary;

	function get selectedNote():INote;
	function set selectedNote(value:INote):void;
}
}
