package de.dittner.testmyself.backend.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.satelliteFlight.command.CommandException;
import de.dittner.testmyself.backend.command.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.model.AppConfig;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.ui.common.audio.mp3.MP3Writer;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class MP3EncodingPhase extends AsyncOperation implements IAsyncCommand {
	public function MP3EncodingPhase(note:Note) {
		this.note = note;
	}

	private var note:Note;

	public function execute():void {
		if (!note.audioComment.isMp3 && note.audioComment.bytes && note.audioComment.bytes.length > 0) {
			try {
				MP3Writer.encodeRawData(note.audioComment.bytes, encodeCompleteHandler);
			}
			catch (error:Error) {
				dispatchError(new CommandException(ErrorCode.MP3_ENCODING_FAILED, error.message));
			}
		}
		else dispatchSuccess();
	}

	private function encodeCompleteHandler(output:ByteArray):void {
		note.audioComment.isMp3 = true;
		note.audioComment.bytes.clear();
		note.audioComment.bytes = output;
		//saveLocally();
		dispatchSuccess();
	}

	private function saveLocally():void {
		var fileStream:FileStream = new FileStream();
		var file:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + "record.mp3");
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeBytes(note.audioComment.bytes, 0, note.audioComment.bytes.length);
		fileStream.close();
	}

	override public function destroy():void {
		super.destroy();
		note = null;
	}
}
}
