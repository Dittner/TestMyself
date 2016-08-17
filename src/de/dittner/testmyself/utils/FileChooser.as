package de.dittner.testmyself.utils {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.LocalStorage;

import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class FileChooser {
	public static const LAST_OPENED_FILE_PATH:String = "LAST_OPENED_FILE_PATH";

	public function FileChooser() {}

	private static var curOp:AsyncOperation;
	private static var file:File;

	public static function browse(filters:Array):IAsyncOperation {
		if (curOp && curOp.isProcessing) return curOp;

		curOp = new AsyncOperation();
		var file:File;
		if (LocalStorage.has(LAST_OPENED_FILE_PATH)) {
			file = new File(LocalStorage.read(LAST_OPENED_FILE_PATH));
			if (!file.exists) file = File.documentsDirectory
		}
		else file = File.documentsDirectory;
		try {
			file.addEventListener(Event.SELECT, fileSelected);
			file.browseForOpen("Select file", filters);
		}
		catch (error:Error) {
			curOp.dispatchError("Browse file error: " + error.message);
		}
		return curOp;
	}

	private static function fileSelected(event:Event):void {
		file = event.target as File;
		LocalStorage.write(LAST_OPENED_FILE_PATH, file.nativePath);
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.READ);
		var bytes:ByteArray = new ByteArray();
		stream.readBytes(bytes, 0, stream.bytesAvailable);
		curOp.dispatchSuccess(bytes);
	}

}
}
