package de.dittner.satelliteFlight.injector {
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.module.RootModule;
import de.dittner.satelliteFlight.module.SFModule;
import de.dittner.satelliteFlight.proxy.SFProxy;
import de.dittner.satelliteFlight.sf_namespace;
import de.dittner.satelliteFlight.utils.SFConstants;
import de.dittner.satelliteFlight.utils.SFException;
import de.dittner.satelliteFlight.utils.SFExceptionMsg;

import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

use namespace sf_namespace;

public class Injector implements IInjector {
	public function Injector(root:RootModule) {
		this.root = root;
	}

	protected var root:RootModule;
	private static const classInjectionPropHash:Object = {};

	public function injectProxies(pendingInjectProxies:Array, proxyHash:Object):void {
		var injectionComplete:Boolean;
		for (var i:int = 0; i < pendingInjectProxies.length; i++) {
			var proxy:SFProxy = pendingInjectProxies[i];
			injectionComplete = true;
			var props:Array = getInjectedProps(proxy);
			for each (var prop:String in props) {
				if (proxy[prop] == null) {
					if (proxyHash[prop]) proxy[prop] = proxyHash[prop];
					else if (root.hasProxy(prop)) proxy[prop] = root.getProxy(prop);
					else {
						injectionComplete = false;
						break;
					}
				}
			}
			if (injectionComplete) {
				pendingInjectProxies.splice(i, 1);
				i--;
				proxy.activating();
			}
		}
	}

	public function injectCommand(cmd:ISFCommand, moduleName:String):void {
		var module:SFModule = root.getModule(moduleName);
		var props:Array = getInjectedProps(cmd);
		for each (var prop:String in props) {
			if (module && module.hasProxy(prop)) cmd[prop] = module.getProxy(prop);
			else if (root.hasProxy(prop)) cmd[prop] = root.getProxy(prop);
			else throw new SFException(SFExceptionMsg.PROXY_NOT_FOUND + "; proxy id: '" + prop + "'; required for command: " + Class(getDefinitionByName(getQualifiedClassName(cmd))) + "; module name: " + moduleName);
		}
	}

	public function injectMediator(m:SFMediator, moduleName:String):void {
		var module:SFModule = root.getModule(moduleName);
		var props:Array = getInjectedProps(m);
		for each (var prop:String in props) {
			if (prop == SFConstants.MEDIATOR_VIEW_INJECT_NAME) continue;
			if (module && module.hasProxy(prop)) m[prop] = module.getProxy(prop);
			else if (root.hasProxy(prop)) m[prop] = root.getProxy(prop);
			else throw new SFException(SFExceptionMsg.PROXY_NOT_FOUND + "; proxy id: '" + prop + "'; required for command: " + Class(getDefinitionByName(getQualifiedClassName(m))) + "; module name: " + moduleName);
		}
	}

	public function hasInjectDeclaration(obj:Object, injectedProp:String):Boolean {
		var props:Array = getInjectedProps(obj);
		for each(var prop:String in props)
			if (prop == injectedProp) return true;
		return false;
	}

	protected function getInjectedProps(obj:Object):Array {
		var className:Class = Class(getDefinitionByName(getQualifiedClassName(obj)));
		if (classInjectionPropHash[className]) return classInjectionPropHash[className];

		var props:Array = [];
		var classDescription:XML = describeType(className);
		var nodesList:XMLList = classDescription.factory.*;
		var nodeCount:int = nodesList.length();
		for (var i:int = 0; i < nodeCount; i++) {
			var node:XML = nodesList[i];
			var nodeName:String = node.name();
			if (nodeName == "variable" || nodeName == "accessor") {
				var metadataList:XMLList = node.metadata;
				var metadataCount:int = metadataList.length();
				for (var j:int = 0; j < metadataCount; j++) {
					nodeName = metadataList[j].@name;
					if (nodeName == "Inject") {
						props.push(node.@name.toString());
					}
				}
			}
		}

		classInjectionPropHash[className] = props;
		return props;
	}
}
}
