package dittner.testmyself.utils.pendingInvoke {

public function clearDelay(index:int):int {
	FTimer.removeTask(index);
    trace("clearDelay");
    return -1;
}
}