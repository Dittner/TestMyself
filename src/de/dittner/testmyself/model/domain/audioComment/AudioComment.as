package de.dittner.testmyself.model.domain.audioComment {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.walter.Walter;

import flash.utils.ByteArray;

[RemoteClass(alias="de.dittner.testmyself.core.model.audioComment.AudioComment")]
public class AudioComment {
	public function AudioComment() {
		super();
	}

	public var id:int = -1;
	public var isMp3:Boolean = false;
	public var bytes:ByteArray;

	//--------------------------------------
	//  isEmpty
	//--------------------------------------
	public function get hasBytes():Boolean {return bytes && bytes.length > 0;}

	//--------------------------------------
	//  storage
	//--------------------------------------
	private function get storage():Storage {
		return Walter.instance.getProxy("storage") as Storage;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var loadOp:IAsyncOperation;
	public function loadMP3():IAsyncOperation {
		if (!loadOp || !loadOp.isProcessing) {
			loadOp = new AsyncOperation();
			if (isMp3 && hasBytes) {
				loadOp.dispatchSuccess(bytes);
			}
			else if (isMp3) {
				loadOp = storage.loadAudioComment(id);
				loadOp.addCompleteCallback(mp3Loaded);
			}
			else {
				loadOp.dispatchError("AudioComment keeps raw data!");
			}
		}
		return loadOp;
	}

	private function mp3Loaded(op:IAsyncOperation):void {
		if (op.isSuccess && op.result is ByteArray) {
			bytes = op.result as ByteArray;
			isMp3 = true;
		}
	}
}
}
