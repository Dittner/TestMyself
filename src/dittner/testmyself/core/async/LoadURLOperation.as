package dittner.testmyself.core.async {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

public class LoadURLOperation extends ProgressOperation {

	public function LoadURLOperation(url:String, dataFormat:String = null) {
		super();
		init(url, dataFormat);
	}

	protected var timeOutToken:uint;

	protected var urlLoader:URLLoader;

	private var _url:String;

	public function get url():String {return _url;}

	protected function init(url:String, dataFormat:String = "text"):void {
		if (!url) throw new Error(url, "url argument must not be null or empty");
		dataFormat ||= URLLoaderDataFormat.TEXT;

		timeOutToken = setTimeout(createLoader, 1, url, dataFormat);
	}

	protected function createLoader(url:String, dataFormat:String):void {
		clearTimeout(timeOutToken);
		urlLoader = new URLLoader();
		urlLoader.dataFormat = dataFormat;
		urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
		urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderErrorHandler);
		urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderErrorHandler);
		urlLoader.load(new URLRequest(url));
	}

	protected function progressHandler(event:ProgressEvent):void {
		_progress = event.bytesLoaded;
		_total = event.bytesTotal;
		notifyProgressChanged();
	}

	protected function removeEventListeners():void {
		if (urlLoader != null) {
			urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderErrorHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderErrorHandler);
			urlLoader = null;
		}
	}

	protected function urlLoaderCompleteHandler(event:Event):void {
		removeEventListeners();
		dispatchSuccess(urlLoader.data);
	}

	protected function urlLoaderErrorHandler(event:Event):void {
		removeEventListeners();
		dispatchError(event['text']);
	}

	public function toString():String {
		return "LoadURLOperation{_url:\"" + _url + "\"}";
	}

}
}
