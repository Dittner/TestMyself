package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.Storage;

import flash.events.SQLEvent;
import flash.net.Responder;

public class CompressDBCmd extends StorageOperation implements IAsyncCommand {
	public function CompressDBCmd(storage:Storage) {
		this.storage = storage;
	}

	private var storage:Storage;

	public function execute():void {
		storage.sqlConnection.compact(new Responder(noteDBCompressed, executeError));
		storage.audioSqlConnection.compact(new Responder(audioDBCompressed, executeError));
	}

	private var isAudioDBCompressed:Boolean = false;
	private function audioDBCompressed(event:SQLEvent):void {
		isAudioDBCompressed = true;
		if (isAudioDBCompressed && isNoteDBCompressed)
			dispatchSuccess();
	}

	private var isNoteDBCompressed:Boolean = false;
	private function noteDBCompressed(event:SQLEvent):void {
		isNoteDBCompressed = true;
		if (isAudioDBCompressed && isNoteDBCompressed)
			dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}
