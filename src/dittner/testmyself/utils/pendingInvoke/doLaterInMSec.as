package dittner.testmyself.utils.pendingInvoke {

public function doLaterInMSec(method:Function, delayMilliSec:uint = 1000):int {
	var delayFrames:uint = Math.ceil(delayMilliSec / Fps.rate);
	return FTimer.addTask(method, delayFrames);
}
}