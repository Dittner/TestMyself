package dittner.testmyself.deutsch.utils.pendingInvalidation {
public function invalidateOf(validateFunc:Function):void {
	Invalidator.add(validateFunc);
}
}