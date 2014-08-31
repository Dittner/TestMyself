package dittner.satelliteFlight.module {
import dittner.satelliteFlight.*;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.satelliteFlight.utils.SFException;
import dittner.satelliteFlight.utils.SFExceptionMsg;

use namespace sf_namespace;

public class SFModule extends SFMediator {
	public function SFModule(name:String) {
		if (!root)
			throw new SFException(SFExceptionMsg.MODULE_ROOT_NOT_FOUND);
		if (!name)
			throw new SFException(SFExceptionMsg.NO_NAME_FOR_MODULE);
		moduleName = name;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	sf_namespace static var root:SFModule;

	protected var cmdClassHash:Object = {};
	protected var proxyHash:Object = {};
	protected var pendingInjectProxies:Array = [];

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  name
	//--------------------------------------
	public function get name():String {return moduleName;}

	//--------------------------------------
	//  hasProxy
	//--------------------------------------
	public function hasProxy(id:String):Boolean {return proxyHash[id] != null;}

	//--------------------------------------
	//  getProxy
	//--------------------------------------
	public function getProxy(id:String):SFProxy {return proxyHash[id];}

	//--------------------------------------
	//  hasCmd
	//--------------------------------------
	public function hasCmd(msg:String):Boolean {return cmdClassHash[msg] != null;}

	//--------------------------------------
	//  getCmdClass
	//--------------------------------------
	public function getCmdClass(msg:String):Class {return cmdClassHash[msg];}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function registerCmd(msg:String, cmdClass:Class):void {
		if (cmdClassHash[msg])
			throw new SFException(SFExceptionMsg.DUPLICATE_CMD + "; message name: " + msg + "; module name: " + name);
		cmdClassHash[msg] = cmdClass;
	}

	public function registerProxy(proxyID:String, proxy:SFProxy):void {
		if (proxyHash[proxyID])
			throw new SFException(SFExceptionMsg.DUPLICATE_PROXY + "; proxy id: " + proxyID + "; module name: " + name);
		proxyHash[proxyID] = proxy;
		pendingInjectProxies.push(proxy);
		proxy.moduleName = name;
		proxy.messageSender = messageSender;
		proxy.injector = injector;
		injector.injectProxies(pendingInjectProxies, proxyHash);
	}

	public function destroy():void {
		super.deactivating();
		cmdClassHash = null;
		for (var proxyName:String in proxyHash) {
			proxyHash[proxyName].deactivating();
		}
		proxyHash = null;
		pendingInjectProxies.length = 0;
		pendingInjectProxies = null;
	}

}
}
