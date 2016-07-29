package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;

import flash.errors.SQLError;
import flash.utils.getQualifiedClassName;

public class StorageOperation extends AsyncOperation {
	public function StorageOperation() {
		super();
	}

	override public function dispatchError(error:* = null):void {
		if (error) {
			var errStr:String = getQualifiedClassName(this) + ": " + error;
			CLog.err(LogCategory.STORAGE, errStr);
		}
		super.dispatchError(error);
	}

	protected function executeError(error:SQLError):void {
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
	}
}
}
