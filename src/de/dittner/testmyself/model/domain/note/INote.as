package de.dittner.testmyself.model.domain.note {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

public interface INote {
	function get id():int;
	function get title():String;
	function get description():String;
	function get audioComment():AudioComment;
	function get vocabulary():Vocabulary;
	function get isNew():Boolean;
	function get isExample():Boolean;
	function get examples():Array;
	function get themes():Vector.<Theme>

	function store():IAsyncOperation;
}
}
