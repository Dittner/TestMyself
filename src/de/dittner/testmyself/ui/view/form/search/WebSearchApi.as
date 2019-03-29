package de.dittner.testmyself.ui.view.form.search {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.language.LanguageID;

public class WebSearchAPI {
	public function WebSearchAPI() {
		super();
	}

	public static function search(noteTitle:String, language:Language):IAsyncOperation {
		if (language.id == LanguageID.DE) {
			var dudenSearchOp:DudenSearchOperation = new DudenSearchOperation(noteTitle);
			dudenSearchOp.run();
			return dudenSearchOp;
		}
		else if (language.id == LanguageID.EN) {
			var cambridgeSearchOp:CambridgeSearchOperation = new CambridgeSearchOperation(language, noteTitle);
			cambridgeSearchOp.run();
			return cambridgeSearchOp;
		}
		else {
			throw new Error('Invalid LanguageID: "' + language.id + '"');
		}
	}
}
}

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.ui.view.form.search.RemoteLoadAudioCommentCmd;
import de.dittner.testmyself.ui.view.form.search.WebSearchResult;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

class DudenSearchOperation extends AsyncOperation {
	private static const SERVER:String = "https://www.duden.de/rechtschreibung/";

	public function DudenSearchOperation(noteTitle:String) {
		this.noteTitle = noteTitle;
		searchResult = new WebSearchResult();
	}

	private var searchResult:WebSearchResult;
	private var noteTitle:String;

	public function run():void {
		noteTitle = correctTitle(noteTitle);
		loadHtml(noteTitle);
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
	private function loadHtml(noteTitle:String):void {
		if (noteTitle) {
			if (!htmlLoader) {
				htmlLoader = new URLLoader();
				htmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				htmlLoader.addEventListener(Event.COMPLETE, htmlLoaderCompleteHandler);
				htmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, htmlLoaderErrorHandler);
				htmlLoader.addEventListener(IOErrorEvent.IO_ERROR, htmlLoaderErrorHandler);
			}
			var request:URLRequest = new URLRequest(SERVER + noteTitle);
			htmlLoader.load(request);
		}
		else {
			dispatchError("DudenSearchCmd: No htmlUrl to load mp3!");
		}
	}

	private function htmlLoaderCompleteHandler(event:Event):void {
		var html:String;
		try {
			html = htmlLoader.data;
		}
		catch (e:Error) {
			dispatchError("DudenSearchCmd: Load duden html with error: " + e.toString());
		}
		var mp3Url:String = getMp3Url(html);
		loadMp3(mp3Url);
	}

	private function htmlLoaderErrorHandler(event:Event):void {
		dispatchError("DudenSearchCmd: Load duden html error: " + event.toString());
	}

	private function getMp3Url(html:String):String {
		if (!html) return "";
		var mp3UrlEndInd:int = html.indexOf(".mp3");
		if (mp3UrlEndInd != -1) {
			var mp3UrlStartInd:int = html.lastIndexOf("https:", mp3UrlEndInd);
			if (mp3UrlStartInd != -1) {
				var res:String = html.substring(mp3UrlStartInd, mp3UrlEndInd);
				return res;
			}
		}
		return "";
	}

	private function loadMp3(url:String):void {
		if (url) {
			var cmd:RemoteLoadAudioCommentCmd = new RemoteLoadAudioCommentCmd(url);
			cmd.addCompleteCallback(mp3Loaded);
			cmd.execute();
		}
		else {
			dispatchSuccess(searchResult);
		}
	}

	private function mp3Loaded(op:IAsyncOperation):void {
		if (op.isSuccess && op.result is AudioComment)
			searchResult.audioComment = op.result;
		dispatchSuccess(searchResult);
	}

}
class CambridgeSearchOperation extends AsyncOperation {
	private static const EN_VOC_URL:String = "https://dictionary.cambridge.org/dictionary/english/";

	public function CambridgeSearchOperation(language:Language, noteTitle:String) {
		this.language = language;
		this.noteTitle = noteTitle;
		searchResult = new WebSearchResult();
		searchResult.tagName = "C2: Proficiency level";
	}

	private var searchResult:WebSearchResult;
	private var language:Language;
	private var noteTitle:String = "";
	private var enVocHtml:String = "";
	private var isEnRuDicRead:Boolean = false;
	private var isWebDataLoaded:Boolean = false;

	public function run():void {
		searchNoteInEnRuDic();
		loadHtml();
	}

	private function searchNoteInEnRuDic():void {
		var op:IAsyncOperation = language.storage.searchInEnRuDic(noteTitle);
		op.addCompleteCallback(searchInEnRuDicComplete);
	}

	private function searchInEnRuDicComplete(op:IAsyncOperation):void {
		if (op.isSuccess && op.result) {
			searchResult.description = op.result["description"] || "";
			searchResult.examples = op.result["examples"] || [];
		}
		else {
			CLog.err(LogTag.STORAGE, "Load note in EN_RU_DIC is failed: " + op.error);
		}
		isEnRuDicRead = true;
		complete();
	}

	private function correctTitle(title:String):String {
		return title.replace(/( )/g, "-");
	}

	private var htmlLoader:URLLoader;
	private function loadHtml():void {
		var url:String = EN_VOC_URL + correctTitle(noteTitle);
		if (url) {
			if (!htmlLoader) {
				htmlLoader = new URLLoader();
				htmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				htmlLoader.addEventListener(Event.COMPLETE, htmlLoaderCompleteHandler);
				htmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, htmlLoaderErrorHandler);
				htmlLoader.addEventListener(IOErrorEvent.IO_ERROR, htmlLoaderErrorHandler);
			}
			var request:URLRequest = new URLRequest(url);
			htmlLoader.load(request);
		}
		else {
			dispatchError("CambridgeSearchOperation: No htmlUrl to load mp3! Note: " + noteTitle);
		}
	}

	private function htmlLoaderCompleteHandler(event:Event):void {
		try {
			enVocHtml = htmlLoader.data;
			readDataFromHtml();
		}
		catch (e:Error) {
			dispatchError("CambridgeSearchOperation: Load html with error: " + e.toString());
		}
	}

	private function readDataFromHtml():void {
		readTag(enVocHtml);
		var mp3Url:String = getMp3Url(enVocHtml);
		loadMp3(mp3Url);
	}

	private function readTag(html:String):void {
		if (html.indexOf(">A1<") != -1) searchResult.tagName = "A1: Beginner level";
		else if (html.indexOf(">A2<") != -1) searchResult.tagName = "A2: Elementary level";
		else if (html.indexOf(">B1<") != -1) searchResult.tagName = "B1: Intermediate level";
		else if (html.indexOf(">B2<") != -1) searchResult.tagName = "B2: Upper-Intermediate level";
		else if (html.indexOf(">C1<") != -1) searchResult.tagName = "C1: Advanced level";
		else searchResult.tagName = "C2: Proficiency level";
	}

	private function htmlLoaderErrorHandler(event:Event):void {
		CLog.err(LogTag.LOAD, "CambridgeSearchOperation: loadHtmlError: " + event.toString());
		dispatchError();
	}

	private static const MP3_TAG:String = 'data-src-mp3="';
	private function getMp3Url(html:String):String {
		if (!html) return "";
		var mp3UrlStartInd:int = html.indexOf(MP3_TAG);
		if (mp3UrlStartInd != -1) {
			html = html.substring(mp3UrlStartInd);
			var mp3UrlEndInd:int = html.indexOf(".mp3");
			if (mp3UrlEndInd != -1) {
				var res:String = html.substring(MP3_TAG.length, mp3UrlEndInd) + ".mp3";
				if(res.indexOf("https") == 0) return res;
				else return "https://dictionary.cambridge.org" + res;
			}
		}
		return "";
	}

	private function loadMp3(url:String):void {
		if (url) {
			var cmd:RemoteLoadAudioCommentCmd = new RemoteLoadAudioCommentCmd(url);
			cmd.addCompleteCallback(mp3Loaded);
			cmd.execute();
		}
		else {
			isWebDataLoaded = true;
			complete();
		}
	}

	private function mp3Loaded(op:IAsyncOperation):void {
		if (op.isSuccess && op.result is AudioComment)
			searchResult.audioComment = op.result;
		isWebDataLoaded = true;
		complete();
	}

	private function complete():void {
		if (isEnRuDicRead && isWebDataLoaded)
			dispatchSuccess(searchResult);
	}

}