package de.dittner.satelliteFlight.message {
import de.dittner.async.IAsyncOperation;

public interface IRequestMessage {
	function get data():Object;
	function onComplete(op:IAsyncOperation):void;
}
}
