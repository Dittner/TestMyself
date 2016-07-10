package de.dittner.satelliteFlight.module {
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.injector.Injector;
import de.dittner.satelliteFlight.message.MessageSender;
import de.dittner.satelliteFlight.sf_namespace;
import de.dittner.satelliteFlight.utils.SFException;
import de.dittner.satelliteFlight.utils.SFExceptionMsg;

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

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function addModule(module:SFModule):void {
		if (moduleHash[module.moduleName]) {
			throw new SFException(SFExceptionMsg.DUPLICATE_MODULE + "; module name: " + moduleName);
		}
		else {
			moduleHash[module.moduleName] = module;
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
