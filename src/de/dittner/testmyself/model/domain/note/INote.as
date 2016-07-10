package de.dittner.testmyself.model.domain.note {
import de.dittner.testmyself.model.domain.audioComment.AudioComment;

public interface INote {
	function get id():int;
	function get title():String;
	function get description():String;
	function get audioComment():AudioComment;
}
}
