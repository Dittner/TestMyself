package dittner.satelliteFlight.injector {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.mediator.SFMediator;

public interface IInjector {
	function injectProxies(pendingInjectProxies:Array, proxyHash:Object):void;
	function injectCommand(cmd:ISFCommand, moduleName:String):void;
	function injectMediator(m:SFMediator, moduleName:String):void
	function hasInjectDeclaration(obj:Object, injectedProp:String):Boolean;
}
}
