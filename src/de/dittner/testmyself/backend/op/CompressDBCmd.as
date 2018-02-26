package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.Storage;

import flash.events.SQLEvent;
import flash.net.Responder;

public class CompressDBCmd extends StorageOperation implements IAsyncCommand  {
	public function CompressDBCmd(storage:Storage) {
		this.storage = storage;
	}

	private var storage:Storage;

	public function execute():void {
		storage.audioSqlConnection.compact(new Responder(executeComplete, executeError));
	}

	private function executeComplete(event:SQLEvent):void {
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}
