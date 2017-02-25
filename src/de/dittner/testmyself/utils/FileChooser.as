package de.dittner.testmyself.utils {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.LocalStorage;
import de.dittner.testmyself.backend.LocalStorageKey;

import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class FileChooser {

	public function FileChooser() {}

	private static var curOp:AsyncOperation;
	private static var file:File;

	public static function browse(filters:Array):IAsyncOperation {
		if (curOp && curOp.isProcessing) return curOp;

		curOp = new AsyncOperation();
		var file:File;
		if (LocalStorage.has(LocalStorageKey.LAST_OPENED_FILE_PATH)) {
			file = new File(LocalStorage.read(LocalStorageKey.LAST_OPENED_FILE_PATH));
			if (!file.exists) file = File.documentsDirectory
		}
		else file = File.documentsDirectory;
		try {
			file.addEventListener(Event.CANCEL, canceledSelected);
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
		file.removeEventListener(Event.CANCEL, canceledSelected);
		file.removeEventListener(Event.SELECT, fileSelected);
		LocalStorage.write(LocalStorageKey.LAST_OPENED_FILE_PATH, file.nativePath);
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.READ);
		var bytes:ByteArray = new ByteArray();
		stream.readBytes(bytes, 0, stream.bytesAvailable);
		curOp.dispatchSuccess(bytes);
	}

	private static function canceledSelected(event:Event):void {
		file = event.target as File;
		file.removeEventListener(Event.CANCEL, canceledSelected);
		file.removeEventListener(Event.SELECT, fileSelected);
		LocalStorage.write(LocalStorageKey.LAST_OPENED_FILE_PATH, file.nativePath);
		curOp.dispatchSuccess();
	}

}
}
