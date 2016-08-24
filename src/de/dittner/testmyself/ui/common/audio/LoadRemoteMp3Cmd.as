package de.dittner.testmyself.ui.common.audio {
import de.dittner.async.AsyncCommand;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

public class LoadRemoteMp3Cmd extends AsyncCommand {

	public static const SERVER:String = "http://www.duden.de/rechtschreibung/";

	public function LoadRemoteMp3Cmd(noteTitleToLoad:String) {
		super();
		this.noteTitleToLoad = correctTitle(noteTitleToLoad);
	}

	private function correctTitle(title:String):String {
		var res:String = title;
		res = res.replace(/(ü)/g, "ue");
		res = res.replace(/(Ü)/g, "Ue");

		res = res.replace(/(ä)/g, "ae");
		res = res.replace(/(Ä)/g, "Ae");

		res = res.replace(/(ö)/g, "oe");
		res = res.replace(/(Ö)/g, "Oe");

		res = res.replace(/(ß)/g, "sz");
		res = res.replace(/(-)/g, "_");

		return res;
	}

	private var htmlLoader:URLLoader;
	private var mp3Loader:URLLoader;
	private var noteTitleToLoad:String = "";

	private function notifyError(errorText:String):void {
		dispatchError(errorText);
		CLog.info(LogCategory.LOAD, errorText);
	}

	override public function execute():void {
		if (noteTitleToLoad) {
			if (!htmlLoader) {
				htmlLoader = new URLLoader();
				htmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				htmlLoader.addEventListener(Event.COMPLETE, htmlLoaderCompleteHandler);
				htmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, htmlLoaderErrorHandler);
				htmlLoader.addEventListener(IOErrorEvent.IO_ERROR, htmlLoaderErrorHandler);
			}
			var request:URLRequest = new URLRequest(SERVER + noteTitleToLoad);
			htmlLoader.load(request);
		}
		else {
			notifyError("No htmlUrl to load mp3!");
		}
	}

	private function htmlLoaderCompleteHandler(event:Event):void {
		var html:String;
		try {
			html = htmlLoader.data;
		}
		catch (e:Error) {
			notifyError("Load duden html with error: " + e.toString());
		}
		var mp3Url:String = getMp3Url(html);
		loadMp3(mp3Url);
	}

	private function htmlLoaderErrorHandler(event:Event):void {
		notifyError("Load duden html error: " + event.toString());
	}

	private function getMp3Url(html:String):String {
		if (!html) return "";
		var mp3UrlEndInd:int = html.indexOf(".mp3");
		if (mp3UrlEndInd != -1) {
			var mp3UrlStartInd:int = html.lastIndexOf("http:", mp3UrlEndInd);
			if (mp3UrlStartInd != -1) {
				var res:String = html.substring(mp3UrlStartInd, mp3UrlEndInd);
				return res;
			}
		}
		return "";
	}

	private function loadMp3(url:String):void {
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
			dispatchSuccess();
		}
	}

	private function mp3LoaderCompleteHandler(event:Event):void {
		var mp3:ByteArray;
		try {
			mp3 = mp3Loader.data as ByteArray;
		}
		catch (e:Error) {
			CLog.info(LogCategory.LOAD, "Load remote mp3 with error: " + e.toString());
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
		notifyError("Load remote mp3 error: " + event.toString());
	}
}
}
