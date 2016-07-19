package de.dittner.testmyself.model.domain.common {
import de.dittner.testmyself.model.domain.audioComment.AudioComment;

public interface ICommentRecordable {
	function get audioComment():AudioComment;
	function set audioComment(value:AudioComment):void;
}
