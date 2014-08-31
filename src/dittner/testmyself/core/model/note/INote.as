package dittner.testmyself.core.model.note {
import flash.utils.ByteArray;

public interface INote {
	function get id():int;
	function get title():String;
	function get description():String;
	function get audioComment():ByteArray;
}
}
