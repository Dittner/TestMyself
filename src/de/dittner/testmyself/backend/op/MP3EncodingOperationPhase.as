package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.ui.common.audio.mp3.MP3Writer;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class MP3EncodingOperationPhase extends AsyncOperation implements IAsyncCommand {
	public function MP3EncodingOperationPhase(comment:AudioComment) {
		this.comment = comment;
	}

	private var comment:AudioComment;

	public function execute():void {
		if (comment && !comment.isMp3 && comment.bytes && comment.bytes.length > 0) {
			try {
				MP3Writer.encodeRawData(comment.bytes, encodeCompleteHandler);
			}
			catch (error:Error) {
				CLog.err(LogCategory.STORAGE, ErrorCode.MP3_ENCODING_FAILED + ": " + error.message);
				dispatchError(ErrorCode.MP3_ENCODING_FAILED);
			}
		}
		else dispatchSuccess();
	}

	private function encodeCompleteHandler(output:ByteArray):void {
		comment.isMp3 = true;
		comment.bytes.clear();
		comment.bytes = output;
		//saveLocally();
		dispatchSuccess();
	}

	private function saveLocally():void {
		var fileStream:FileStream = new FileStream();
		var file:File = File.documentsDirectory.resolvePath(Device.dbRootPath + "record.mp3");
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeBytes(comment.bytes, 0, comment.bytes.length);
		fileStream.close();
	}

	override public function destroy():void {
		super.destroy();
		comment = null;
	}
}
}
