package dittner.utils {

public function invalidateOf(validateFunc:Function):void {
	Invalidator.add(validateFunc);
}
}