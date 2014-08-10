package dittner.testmyself.model.common {
import flash.utils.ByteArray;

public interface ITransUnit {
	function get id():int;
	function get origin():String;
	function get translation():String;
	function get audioRecord():ByteArray;
}
}
