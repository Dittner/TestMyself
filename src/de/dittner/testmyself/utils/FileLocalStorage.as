package de.dittner.testmyself.utils {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.LocalStorage;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

public class FileLocalStorage {
	public static const LAST_SAVED_DIR_PATH:String = "LAST_SAVED_DIR_PATH";

	public function FileLocalStorage() {}

	private static var curOp:AsyncOperation;
	private static var bytes:ByteArray;
	private static var fileName:String;

	public static function store(ba:ByteArray, fileName:String):IAsyncOperation {
		if (curOp && curOp.isProcessing) return curOp;

		if (bytes) bytes.clear();
		bytes = ba;
		FileLocalStorage.fileName = fileName;

		curOp = new AsyncOperation();
		var file:File;
		if (LocalStorage.has(LAST_SAVED_DIR_PATH)) {
			file = new File(LocalStorage.read(LAST_SAVED_DIR_PATH));
			if (!file.exists) file = File.documentsDirectory;
		}
		else file = File.documentsDirectory;
		try {
			file.addEventListener(Event.SELECT, dirSelected);
			file.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			file.browseForDirectory("Wählen Sie bitte den Ordner");
		}
		catch (error:Error) {
			curOp.dispatchError("Browse file error: " + error.message);
		}

		return curOp;
	}

	private static function ioError(event:Event):void {
		curOp.dispatchError();
	}

	private static function dirSelected(event:Event):void {
		var dir:File = event.target as File;
		LocalStorage.write(LAST_SAVED_DIR_PATH, dir.nativePath);
		var fileStream:FileStream = new FileStream();
		var file:File = new File(dir.nativePath + File.separator + fileName);
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeBytes(bytes, 0, bytes.length);
		fileStream.close();
		curOp.dispatchSuccess();
	}

}
}
