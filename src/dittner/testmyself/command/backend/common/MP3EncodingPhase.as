package dittner.testmyself.command.backend.common {
import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.model.common.TransUnit;
import dittner.testmyself.view.common.audio.mp3.MP3Writer;

import flash.utils.ByteArray;

public class MP3EncodingPhase extends PhaseOperation {
	public function MP3EncodingPhase(transUnit:TransUnit, origin:TransUnit = null) {
		this.transUnit = transUnit;
		this.origin = origin;
	}

	private var transUnit:TransUnit;
	private var origin:TransUnit;

	override public function execute():void {
		if (origin && origin.audioRecord == transUnit.audioRecord) {
			dispatchComplete();
		}
		else if (transUnit.audioRecord && transUnit.audioRecord.length > 100) {
			try {
				MP3Writer.encodeRawData(transUnit.audioRecord, encodeCompleteHandler);
			}
			catch (error:Error) {
				throw new CommandException(ErrorCode.MP3_ENCODING_FAILED, error.message);
			}
		}
		else dispatchComplete();
	}

	private function encodeCompleteHandler(output:ByteArray):void {
		transUnit.audioRecord.clear();
		transUnit.audioRecord = output;
		//saveLocally();
		dispatchComplete();
	}

	/*private function saveLocally():void {
	 var fileStream:FileStream = new FileStream();
	 var file:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + "record.mp3");
	 fileStream.open(file, FileMode.WRITE);
	 fileStream.writeBytes(transUnit.audioRecord, 0, transUnit.audioRecord.length);
	 fileStream.close();
	 }*/

	override public function destroy():void {
		super.destroy();
		transUnit = null;
	}
}
}
