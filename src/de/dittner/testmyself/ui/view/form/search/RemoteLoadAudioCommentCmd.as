package de.dittner.testmyself.ui.view.form.search {
import de.dittner.async.AsyncCommand;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

public class RemoteLoadAudioCommentCmd extends AsyncCommand {
	public function RemoteLoadAudioCommentCmd(url:String) {
		super();
		this.url = url;
	}

	private var url:String;
	private var mp3Loader:URLLoader;

	override public function execute():void {
		if (url) {
			if (!mp3Loader) {
				mp3Loader = new URLLoader();
				mp3Loader.dataFormat = URLLoaderDataFormat.BINARY;
				mp3Loader.addEventListener(Event.COMPLETE, mp3LoaderCompleteHandler);
				mp3Loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, mp3LoaderErrorHandler);
				mp3Loader.addEventListener(IOErrorEvent.IO_ERROR, mp3LoaderErrorHandler);
			}
			var request:URLRequest = new URLRequest(url);
			mp3Loader.load(request);
		}
		else {
			dispatchError("DownloadAudioCommentCmd: Invalid url!");
		}
	}

	private function mp3LoaderCompleteHandler(event:Event):void {
		var mp3:ByteArray;
		try {
			mp3 = mp3Loader.data as ByteArray;
		}
		catch (e:Error) {
			CLog.info(LogTag.LOAD, "DownloadAudioCommentCmd: Load remote mp3 with error: " + e.toString());
		}

		var ac:AudioComment;
		if (mp3 && mp3.length > 0) {
			ac = new AudioComment();
			ac.bytes = mp3;
			ac.bytes.position = 0;
			ac.isMp3 = true;
		}

		dispatchSuccess(ac);
	}

	private function mp3LoaderErrorHandler(event:Event):void {
		dispatchError("DownloadAudioCommentCmd: Load remote mp3 error: " + event.toString());
	}

}
}