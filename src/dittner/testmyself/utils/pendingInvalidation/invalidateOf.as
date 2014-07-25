package dittner.testmyself.utils.pendingInvalidation {
public function invalidateOf(validateFunc:Function):void {
	Invalidator.add(validateFunc);
}
}