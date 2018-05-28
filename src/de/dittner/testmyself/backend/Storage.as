package de.dittner.testmyself.backend {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.ProgressCommand;
import de.dittner.async.utils.doLaterInSec;
import de.dittner.testmyself.backend.cmd.ClearTestHistoryCmd;
import de.dittner.testmyself.backend.cmd.LoadAllTagsCmd;
import de.dittner.testmyself.backend.cmd.LoadAudioCommentCmd;
import de.dittner.testmyself.backend.cmd.LoadHashDataCmd;
import de.dittner.testmyself.backend.cmd.LoadNoteByNoteIDCmd;
import de.dittner.testmyself.backend.cmd.LoadNotePageCmd;
import de.dittner.testmyself.backend.cmd.LoadTaskIDsCmd;
import de.dittner.testmyself.backend.cmd.LoadTestStatisticsCmd;
import de.dittner.testmyself.backend.cmd.LoadTestTaskCmd;
import de.dittner.testmyself.backend.cmd.LoadVocabularyInfoCmd;
import de.dittner.testmyself.backend.cmd.MergeTagsCmd;
import de.dittner.testmyself.backend.cmd.RemoveNoteCmd;
import de.dittner.testmyself.backend.cmd.RemoveNotesByTagCmd;
import de.dittner.testmyself.backend.cmd.RemoveTagCmd;
import de.dittner.testmyself.backend.cmd.ReplaceTextInNoteTblCmd;
import de.dittner.testmyself.backend.cmd.RunDataBaseCmd;
import de.dittner.testmyself.backend.cmd.SearchNoteInEnRuDicCmd;
import de.dittner.testmyself.backend.cmd.SearchNotesCmd;
import de.dittner.testmyself.backend.cmd.SelectAllNotesTitlesCmd;
import de.dittner.testmyself.backend.cmd.StoreHashDataCmd;
import de.dittner.testmyself.backend.cmd.StoreNoteCmd;
import de.dittner.testmyself.backend.cmd.StoreTagCmd;
import de.dittner.testmyself.backend.cmd.StoreTestTaskCmd;
import de.dittner.testmyself.backend.deferredOperation.IDeferredCommandManager;
import de.dittner.testmyself.backend.op.CompressDBCmd;
import de.dittner.testmyself.backend.op.LoadAllExamplesOperation;
import de.dittner.testmyself.backend.tileStorage.GenerateTilesCommand;
import de.dittner.testmyself.backend.tileStorage.TileSQLLib;
import de.dittner.testmyself.backend.tileStorage.cmd.LoadAllTilesCmd;
import de.dittner.testmyself.backend.tileStorage.cmd.StoreTileCmd;
import de.dittner.testmyself.backend.utils.HashData;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.common.input.MXLabel;
import de.dittner.testmyself.ui.common.page.NotePage;
import de.dittner.testmyself.ui.common.page.SearchPage;
import de.dittner.testmyself.ui.common.page.TestPage;
import de.dittner.testmyself.ui.common.tile.Tile;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.utils.Values;
import de.dittner.walter.WalterProxy;

import flash.data.SQLConnection;
import flash.display.BitmapData;
import flash.events.SQLErrorEvent;
import flash.events.SQLEvent;
import flash.filesystem.File;

import flashx.textLayout.formats.TextAlign;

import mx.core.FlexGlobals;

import spark.components.Application;

public class Storage extends WalterProxy {
	public static const STORAGE_HAS_TILES_KEY:String = "TILE_STORAGE_HAS_TILES_KEY";
	public static const APP_VERSION_KEY:String = "APP_VERSION_KEY";

	public function Storage() {
		super();
		_hasTiles = LocalStorage.read(STORAGE_HAS_TILES_KEY);
	}

	[Inject]
	public var appModel:AppModel;
	[Inject]
	public var deferredCommandManager:IDeferredCommandManager;

	public var exampleHash:Object = {};
	public var tileBitmapDataCache:Object = {};

	private var _sqlConnection:SQLConnection;
	public function get sqlConnection():SQLConnection {return _sqlConnection;}

	private var _audioSqlConnection:SQLConnection;
	public function get audioSqlConnection():SQLConnection {return _audioSqlConnection;}

	private var _enRuDicSqlConnection:SQLConnection;
	public function get enRuDicSqlConnection():SQLConnection {return _enRuDicSqlConnection;}

	private var _tileSqlConnection:SQLConnection;
	public function get tileSqlConnection():SQLConnection {return _tileSqlConnection;}

	//--------------------------------------
	//  hasTiles
	//--------------------------------------
	private var _hasTiles:Boolean = false;
	public function get hasTiles():Boolean {return _hasTiles;}
	public function set hasTiles(value:Boolean):void {
		if (_hasTiles != value) {
			_hasTiles = value;
			LocalStorage.write(STORAGE_HAS_TILES_KEY, hasTiles);
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {
		deferredCommandManager.stop();
		reloadDataBase();
	}

	public function reloadDataBase():IAsyncOperation {
		exampleHash = {};

		if (sqlConnection)
			sqlConnection.close();

		if (audioSqlConnection)
			audioSqlConnection.close();

		if (enRuDicSqlConnection)
			enRuDicSqlConnection.close();

		var cmd:IAsyncCommand = new RunDataBaseCmd(Device.noteDBPath, SQLLib.getNoteDBTables());
		cmd.addCompleteCallback(dataBaseReadyHandler);
		cmd.execute();

		return cmd;
	}

	private function dataBaseReadyHandler(opEvent:*):void {
		_sqlConnection = opEvent.result as SQLConnection;

		var cmd:IAsyncCommand = new RunDataBaseCmd(Device.audioDBPath, SQLLib.getAudioDBTables());
		cmd.addCompleteCallback(audioDataBaseReadyHandler);
		cmd.execute();
	}

	private function audioDataBaseReadyHandler(opEvent:*):void {
		_audioSqlConnection = opEvent.result as SQLConnection;

		_enRuDicSqlConnection = new SQLConnection();
		var dbFile:File = File.applicationDirectory.resolvePath("dictionary/EN_RU_DIC.db");
		if (!dbFile.exists) throw new Error("Не обнаружена база данных EN_RU_DIC по адресу: " + dbFile.nativePath);

		_enRuDicSqlConnection.addEventListener(SQLEvent.OPEN, enRuDicDataBaseReadyHandler);
		_enRuDicSqlConnection.addEventListener(SQLErrorEvent.ERROR, enRuDicDBErrorHandler);
		_enRuDicSqlConnection.openAsync(dbFile);
	}

	private function enRuDicDBErrorHandler(event:SQLErrorEvent):void {
		throw new Error("Не удалось открыть базу данных EN_RU_DIC: " + event.error);
	}

	private function enRuDicDataBaseReadyHandler(opEvent:*):void {
		removeOldTilesDB();
		var cmd:IAsyncCommand = new RunDataBaseCmd(Device.tileDBPath, [TileSQLLib.CREATE_TILE_TBL]);
		cmd.addCompleteCallback(tileDataBaseReadyHandler);
		cmd.execute();
	}

	private function removeOldTilesDB():void {
		var dbFile:File = File.documentsDirectory.resolvePath(Device.tileDBPath);
		if (Device.appVersion != LocalStorage.read(APP_VERSION_KEY) && dbFile.exists) {
			CLog.info(LogTag.UI, "Irrelevant Tiles DB is deleting...");
			dbFile.deleteFile();
		}
	}

	private function tileDataBaseReadyHandler(opEvent:*):void {
		_tileSqlConnection = opEvent.result as SQLConnection;
		LocalStorage.write(APP_VERSION_KEY, Device.appVersion);

		deferredCommandManager.start();

		var cmd:IAsyncCommand = new LoadAllExamplesOperation(this);
		deferredCommandManager.add(cmd);

		cmd = new LoadAllTilesCmd(this);
		deferredCommandManager.add(cmd);

		var progressCmd:ProgressCommand = new GenerateTilesCommand(this);
		progressCmd.addCompleteCallback(tileGeneratingComplete);
		progressCmd.addProgressCallback(tileGeneratingProgress);
		deferredCommandManager.add(progressCmd);
	}

	private function tileGeneratingComplete(op:IAsyncOperation):void {
		if (op.isSuccess) {
			CLog.info(LogTag.UI, "Графика загружена из БД");
			hideMsg();
		}
		else {
			CLog.err(LogTag.UI, "Tiles generating is failed! Details: " + op.error);
			showMsg("GUI's generating is failed! Details: " + op.error);
			doLaterInSec(hideMsg, 20);
		}
	}

	private function tileGeneratingProgress(value:Number):void {
		if (value < 1) {
			showMsg(Math.floor(value * 100) + "%");
		}
	}

	private var msgLabel:MXLabel;
	private function showMsg(msg:String):void {
		if (!msgLabel) {
			msgLabel = new MXLabel();
			msgLabel.color = AppColors.WHITE;
			msgLabel.fontSize = Values.PT18;
			msgLabel.textAlign = TextAlign.CENTER;
			msgLabel.width = Device.width;
			msgLabel.verticalCenter = 0;
			msgLabel.horizontalCenter = 0;
		}

		msgLabel.text = msg;
		if (!msgLabel.parent) {
			(FlexGlobals.topLevelApplication as Application).addElement(msgLabel);
		}
	}

	private function hideMsg():void {
		if (msgLabel && msgLabel.parent) {
			(FlexGlobals.topLevelApplication as Application).removeElement(msgLabel);
		}
	}

	public function loadVocabularyInfo(v:Vocabulary):IAsyncOperation {
		var op:IAsyncCommand = new LoadVocabularyInfoCmd(this, v);
		deferredCommandManager.add(op);
		return op;
	}

	public function compressDB():IAsyncOperation {
		var op:IAsyncCommand = new CompressDBCmd(this);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  Notes
	//--------------------------------------

	public function storeNote(note:Note):IAsyncOperation {
		var op:IAsyncCommand = new StoreNoteCmd(this, note);
		deferredCommandManager.add(op);
		return op;
	}

	public function removeNote(note:Note):IAsyncOperation {
		var op:IAsyncCommand = new RemoveNoteCmd(this, note.id);
		deferredCommandManager.add(op);
		return op;
	}

	public function removeNotesByTag(tag:Tag):IAsyncOperation {
		var op:IAsyncCommand = new RemoveNotesByTagCmd(this, tag);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadNotePage(page:NotePage):IAsyncOperation {
		var op:IAsyncCommand = new LoadNotePageCmd(this, page);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadAllNotesTitles(v:Vocabulary):IAsyncOperation {
		var op:IAsyncCommand = new SelectAllNotesTitlesCmd(this, v);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadNote(v:Vocabulary, noteID:int):IAsyncOperation {
		var op:IAsyncCommand = new LoadNoteByNoteIDCmd(this, v, noteID);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadAudioComment(noteID:int):IAsyncOperation {
		var op:IAsyncCommand = new LoadAudioCommentCmd(this, noteID);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  Tags
	//--------------------------------------

	public function storeTag(tag:Tag):IAsyncOperation {
		var op:IAsyncCommand = new StoreTagCmd(this, tag);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadAllTags(vocabulary:Vocabulary):IAsyncOperation {
		var op:IAsyncCommand = new LoadAllTagsCmd(this, vocabulary);
		deferredCommandManager.add(op);
		return op;
	}

	public function removeTag(tag:Tag):IAsyncOperation {
		var op:IAsyncCommand = new RemoveTagCmd(this, tag);
		deferredCommandManager.add(op);
		return op;
	}

	public function mergeTags(srcTag:Tag, destTag:Tag):IAsyncOperation {
		var op:IAsyncCommand = new MergeTagsCmd(this, srcTag, destTag);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  search
	//--------------------------------------

	public function searchNotes(page:SearchPage):IAsyncOperation {
		var op:IAsyncCommand = new SearchNotesCmd(this, page);
		deferredCommandManager.add(op);
		return op;
	}

	public function replaceTextInNoteTable(srcText:String, destText:String, langID:uint):IAsyncOperation {
		var op:IAsyncCommand = new ReplaceTextInNoteTblCmd(this, srcText, destText, langID);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  test
	//--------------------------------------

	public function storeTestTask(task:TestTask):IAsyncOperation {
		var op:IAsyncCommand = new StoreTestTaskCmd(this, task);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadTestStatistics(page:TestPage):IAsyncOperation {
		var op:IAsyncCommand = new LoadTestStatisticsCmd(this, page);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadTaskIDs(page:TestPage):IAsyncOperation {
		var op:IAsyncCommand = new LoadTaskIDsCmd(this, page);
		deferredCommandManager.add(op);
		return op;
	}

	public function loadTestTask(test:Test, taskID:int):IAsyncOperation {
		var op:IAsyncCommand = new LoadTestTaskCmd(this, test, taskID);
		deferredCommandManager.add(op);
		return op;
	}

	public function clearTestHistory(test:Test):IAsyncOperation {
		var op:IAsyncCommand = new ClearTestHistoryCmd(this, test);
		deferredCommandManager.add(op);
		return op;
	}

	//--------------------------------------
	//  tiles
	//--------------------------------------

	public function storeTile(tile:Tile):IAsyncOperation {
		return new StoreTileCmd(this, tile);
	}

	public function getTileBitmapData(tileID:String):BitmapData {
		return tileBitmapDataCache[tileID];
	}

	public function logCachedTilesSize():void {
		var totalBytes:Number = 0;
		var totalTiles:int = 0;
		var bytes:Number;
		var bd:BitmapData;
		for (var prop:String in tileBitmapDataCache) {
			bd = tileBitmapDataCache[prop];
			totalTiles++;
			bytes = bd.width * bd.height * 4;
			totalBytes += bytes;
		}
		CLog.info(LogTag.UI, totalTiles + " tiles have been cashed. Total size = " + bytesToMb(totalBytes) + " Mb");
	}

	private function bytesToMb(value:Number):Number {
		var res:Number = value / 1024 / 1024;
		return Math.round(res * 100) / 100;
	}

	//--------------------------------------
	//  hash
	//--------------------------------------

	public function store(hashData:HashData):IAsyncOperation {
		var cmd:IAsyncCommand = new StoreHashDataCmd(this, hashData);
		cmd.execute();
		return cmd;
	}

	public function load(hashDataKey:String):IAsyncOperation {
		var cmd:IAsyncCommand = new LoadHashDataCmd(this, hashDataKey);
		cmd.execute();
		return cmd;
	}

	//--------------------------------------
	//  en-ru dictionary
	//--------------------------------------

	public function searchInEnRuDic(noteTitle:String):IAsyncOperation {
		var cmd:IAsyncCommand = new SearchNoteInEnRuDicCmd(this, noteTitle);
		cmd.execute();
		return cmd;
	}

}
}