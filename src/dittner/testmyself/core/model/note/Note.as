package dittner.testmyself.core.model.note {
import dittner.testmyself.core.model.audioComment.AudioComment;

public class Note implements INote {
	public function Note() {}

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:int = -1;
	public function get id():int {return _id;}
	public function set id(value:int):void {_id = value;}

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String = "";
	public function get title():String {return _title;}
	public function set title(value:String):void {_title = value || "";}

	//--------------------------------------
	//  description
	//--------------------------------------
	private var _description:String;
	public function get description():String {return _description;}
	public function set description(value:String):void {_description = value || "";}

	//--------------------------------------
	//  audioComment
	//--------------------------------------
	private var _audioComment:AudioComment = new AudioComment();
	public function get audioComment():AudioComment {return _audioComment;}
	public function set audioComment(value:AudioComment):void {_audioComment = value || new AudioComment();}

	public function toSQLData():Object {
		var res:Object = {};
		res.title = title;
		res.description = description;
		res.audioComment = audioComment.bytes ? audioComment : null;
		return res;
	}

}
}
