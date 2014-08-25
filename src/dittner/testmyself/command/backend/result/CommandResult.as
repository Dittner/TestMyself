package dittner.testmyself.command.backend.result {
public class CommandResult {
	public function CommandResult(data:Object = null, details:String = "") {
		this.data = data || {};
		this.details = details;
	}

	public static const OK:CommandResult = new CommandResult(null, "OK");

	public var data:Object;
	public var details:String = "";
}
}
