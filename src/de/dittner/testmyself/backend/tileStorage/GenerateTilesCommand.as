package de.dittner.testmyself.backend.tileStorage {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.ProgressCommand;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.ui.common.tile.ClassParser;
import de.dittner.testmyself.ui.common.tile.Tile;
import de.dittner.testmyself.ui.common.tile.TileID;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

public class GenerateTilesCommand extends ProgressCommand {

	public function GenerateTilesCommand(storage:Storage) {
		this.storage = storage;
		//retinaRasterTileIDHash[TileID.TASK_AMOUNT_BG] = true;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	public var tilesIDs:Array = [];
	public var totalTiles:int;
	private var storage:Storage;
	private var tilesMC:MovieClip;
	private var retinaRasterTileIDHash:Object = {};

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function execute():void {
		if (storage.hasTiles) {
			CLog.info(LogTag.UI, "Графика уже сгенерирована");
			storage.logCachedTilesSize();
			setProgress(1);
			dispatchSuccess();
		}
		else {
			CLog.info(LogTag.UI, "Графика ещё не сгенерирована");
			setProgress(0);
			loadTilesSWF();
		}
	}

	private function loadTilesSWF():void {
		var ldr:Loader = new Loader();
		var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
		loaderContext.allowLoadBytesCodeExecution = true;
		ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, tilesSWFLoadFailed);
		ldr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, tilesSWFLoadFailed);
		ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onTilesSWFLoad);

		var request:URLRequest = new URLRequest("swf/tiles.swf");
		request.cacheResponse = false;
		request.useCache = false;
		ldr.load(request, loaderContext);
	}

	private function tilesSWFLoadFailed(event:ErrorEvent):void {
		dispatchError(event.toString());
	}

	private function onTilesSWFLoad(event:Event):void {
		CLog.logMemoryAndFPS(true);
		CLog.info(LogTag.UI, "SWF-файл с графикой успешно загружен");

		tilesMC = event.target.content;
		tilesIDs = ClassParser.parseEnumReturnValues(TileID);
		totalTiles = tilesIDs.length;
		generateNextTile();
	}

	private function generateNextTile():void {
		if (tilesIDs.length > 0) {
			setProgress(1 - tilesIDs.length / totalTiles);
			var id:String = tilesIDs.shift();
			if (hasBitmapData(id)) {
				var storeTileOp:IAsyncOperation = storeTile(id, getBitmapData(id));
				storeTileOp.addCompleteCallback(tileStored);
				if (storeTileOp is IAsyncCommand) (storeTileOp as IAsyncCommand).execute();
			}
			else {
				CLog.warn(LogTag.UI, "MovieClip tile with id = '" + id + "' is mismatch");
			}
		}
		else {
			CLog.logMemoryAndFPS(true);
			CLog.info(LogTag.UI, "Графика успешно сгенерирована!");

			setProgress(1);
			storage.hasTiles = true;
			storage.logCachedTilesSize();
			dispatchSuccess();
		}
	}

	public function hasBitmapData(id:String):Boolean {
		return tilesMC[id] != null;
	}

	private function tileStored(op:IAsyncOperation):void {
		if (op.isSuccess) generateNextTile();
		else dispatchError(op.error);
	}

	private var sprite:Sprite = new Sprite();
	private static const RETINA_SCREEN_WIDTH:uint = 1536;
	public function getBitmapData(id:String):BitmapData {
		var mc:MovieClip = tilesMC[id] as MovieClip;
		if (retinaRasterTileIDHash[id])
			mc.scaleX = mc.scaleY = Math.min(1, Device.width / RETINA_SCREEN_WIDTH);
		else
			mc.scaleX = mc.scaleY = Device.factor;

		mc.x = Math.ceil(mc.width / 2);
		mc.y = Math.ceil(mc.height / 2);
		sprite.addChild(mc);
		var bd:BitmapData = new BitmapData(Math.ceil(mc.width), Math.ceil(mc.height), true, 0x00000000);
		bd.drawWithQuality(sprite, null, null, null, null, true, StageQuality.BEST);
		sprite.removeChild(mc);

		mc = null;
		return bd;
	}

	private function storeTile(id:String, bd:BitmapData):IAsyncOperation {
		var tile:Tile = new Tile(id);
		tile.bitmapData = bd;
		return tile.store();
	}

}
}