package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.deutsch.view.common.audio.mp3.MP3Writer;

import flash.utils.ByteArray;

public class MP3EncodingPhase extends PhaseOperation {
	public function MP3EncodingPhase(note:Note) {
		this.note = note;
	}

	private var note:Note;

	override public function execute():void {
		if (!note.audioComment.isMp3 && note.audioComment.bytes && note.audioComment.bytes.length > 0) {
			try {
				MP3Writer.encodeRawData(note.audioComment.bytes, encodeCompleteHandler);
			}
			catch (error:Error) {
				throw new CommandException(ErrorCode.MP3_ENCODING_FAILED, error.message);
			}
		}
		else dispatchComplete();
	}

	private function encodeCompleteHandler(output:ByteArray):void {
		note.audioComment.isMp3 = true;
		note.audioComment.bytes.clear();
		note.audioComment.bytes = output;
		//saveLocally();
		dispatchComplete();
	}

	/*private function saveLocally():void {
	 var fileStream:FileStream = new FileStream();
	 var file:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + "record.mp3");
	 fileStream.open(file, FileMode.WRITE);
	 fileStream.writeBytes(note.audioRecord, 0, note.audioRecord.length);
	 fileStream.close();
	 }*/

	override public function destroy():void {
		super.destroy();
		note = null;
	}
}
}