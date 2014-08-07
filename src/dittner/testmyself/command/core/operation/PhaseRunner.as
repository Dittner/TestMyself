package dittner.testmyself.command.core.operation {
import dittner.testmyself.utils.ClassUtils;

public class PhaseRunner {
	public function PhaseRunner() {
	}

	public var completeCallback:Function;
	public var errorCallback:Function;

	protected var executing:Boolean = false;

	protected var phaseClassInfoQueue:Vector.<ClassInfo> = new <ClassInfo>[];
	public function addPhase(phaseClass:Class, ...args):void {
		phaseClassInfoQueue.push(new ClassInfo(phaseClass, args));
	}

	public function execute():void {
		if (executing) {
			throw new Error("Phase runner is executing!");
		}
		else {
			executing = true;
			executeNextPhase();
		}
	}

	internal function executeNextPhase():void {
		if (phaseClassInfoQueue.length == 0) {
			completeCallback();
			destroy();
		}
		else {
			var info:ClassInfo = phaseClassInfoQueue.shift();
			var phase:PhaseOperation = ClassUtils.instantiate(info.clazz, info.args);
			phase.completeCallback = executeNextPhase;
			phase.errorCallback = errorHandler;
			phase.execute();
		}
	}

	private function errorHandler(msg:String):void {
		errorCallback(msg);
		destroy();
	}

	protected function destroy():void {
		phaseClassInfoQueue = null;
		completeCallback = null;
		errorCallback = null;
	}
}
}
class ClassInfo {
	public function ClassInfo(clazz:Class, args:Array) {
		this.clazz = clazz;
		this.args = args;
	}

	public var clazz:Class;
	public var args:Array;
}