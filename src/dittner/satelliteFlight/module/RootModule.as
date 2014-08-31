package dittner.satelliteFlight.module {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.injector.Injector;
import dittner.satelliteFlight.message.MessageSender;
import dittner.satelliteFlight.sf_namespace;
import dittner.satelliteFlight.utils.SFException;
import dittner.satelliteFlight.utils.SFExceptionMsg;

use namespace sf_namespace;

public class RootModule extends SFModule {
	public function RootModule(name:String) {
		injector = new injectorClass(this);
		messageSender = new messageSenderClass(this);
		root = this;
		super(name);
		proxyHash["rootModule"] = this;
	}

	public static var messageSenderClass:Class = MessageSender;
	public static var injectorClass:Class = Injector;
	protected var moduleHash:Object = {};

	//--------------------------------------
	//  getModule
	//--------------------------------------
	public function getModule(name:String):SFModule {
		return this.name == name ? this : moduleHash[name];
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function addModule(module:SFModule):void {
		if (moduleHash[module.name]) {
			throw new SFException(SFExceptionMsg.DUPLICATE_MODULE + "; module name: " + name);
		}
		else {
			moduleHash[module.name] = module;
			module.messageSender = messageSender;
			module.injector = injector;
		}
	}

	public function createModuleCommand(moduleName:String, msg:String):ISFCommand {
		var module:SFModule = getModule(moduleName);
		if (!module)
			throw new SFException(SFExceptionMsg.MODULE_NOT_FOUND + "; module name:" + moduleName);

		var cmdClass:Class;
		var cmd:ISFCommand;

		if (module.hasCmd(msg)) cmdClass = module.getCmdClass(msg);
		else if (hasCmd(msg)) cmdClass = getCmdClass(msg);
		else throw new SFException(SFExceptionMsg.COMMAND_NOT_FOUND + "; msg: " + msg + "; module name: " + moduleName);
		cmd = new cmdClass;
		injector.injectCommand(cmd, moduleName);

		return cmd;
	}

	override public function destroy():void {
		for (var moduleChildName:String in moduleHash) {
			moduleHash[moduleChildName].destroy();
		}
		super.destroy();
	}
}
}
