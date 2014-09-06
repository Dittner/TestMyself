package dittner.testmyself.core.model.note {
import dittner.testmyself.core.model.audioComment.AudioComment;

public interface INote {
	function get id():int;
	function get title():String;
	function get description():String;
	function get audioComment():AudioComment;
}
}
