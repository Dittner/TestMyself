package dittner.testmyself.command.core.deferredComandManager {
import mvcexpress.mvc.Command;

public class DeferredCommand extends Command {
	public function DeferredCommand() {}

	[Inject]
	public var deferredCommandManager:IDeferredCommandManager;

	public var data:Object;

	public var completeFunc:Function;
	public var errorFunc:Function;

	private var executed:Boolean = false;
	final public function execute(data:Object = null):void {
		if (!executed) {
			executed = true;
			this.data = data;
			deferredCommandManager.push(this);
		}
		else throw new Error("You should invoke DeferredCommand at once!");
	}

	/*abstract*/
	public function process():void {}

	final public function dispatchComplete():void {
		completeFunc();
		destroy();
	}

	final public function dispatchError(msg:String = ""):void {
		errorFunc(msg);
		destroy();
	}

	/*abstract*/
	public function destroy():void {

	}
}
}
