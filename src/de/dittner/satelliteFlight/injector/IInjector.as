package de.dittner.satelliteFlight.injector {
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.mediator.SFMediator;

public interface IInjector {
	function injectProxies(pendingInjectProxies:Array, proxyHash:Object):void;
	function injectCommand(cmd:ISFCommand, moduleName:String):void;
	function injectMediator(m:SFMediator, moduleName:String):void
	function hasInjectDeclaration(obj:Object, injectedProp:String):Boolean;
}
}
