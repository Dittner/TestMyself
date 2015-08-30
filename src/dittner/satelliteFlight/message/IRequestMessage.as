package dittner.satelliteFlight.message {
import dittner.testmyself.core.async.IAsyncOperation;

public interface IRequestMessage {
	function get data():Object;
	function onComplete(op:IAsyncOperation):void;
}
}
