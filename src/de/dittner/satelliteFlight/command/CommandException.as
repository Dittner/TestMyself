package de.dittner.satelliteFlight.command {
public class CommandException extends Error {
	public function CommandException(msg:String, details:String) {
		super(msg);
		_details = details;
	}

	private var _details:String = "";
	public function get details():String {
		return _details;
	}

}
}
