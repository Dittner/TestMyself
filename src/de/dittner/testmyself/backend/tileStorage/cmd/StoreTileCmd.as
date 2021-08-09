package de.dittner.testmyself.backend.tileStorage.cmd {
import de.dittner.async.AsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.tileStorage.TileSQLLib;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.ui.common.tile.Tile;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.ByteArray;

public class StoreTileCmd extends AsyncOperation {

	public function StoreTileCmd(storage:Storage, tile:Tile) {
		super();
		this.storage = storage;
		this.tile = tile;
		execute();
	}

	private var storage:Storage;
	private var tile:Tile;
	private var total:int = 0;
	private var tileBytes:ByteArray;

	private function execute():void {
		var sqlParams:Object = tileToSQLParams(tile);
		var sqlText:String = needUpdate(tile) ? TileSQLLib.UPDATE_TILE : TileSQLLib.INSERT_TILE;

		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(sqlText, sqlParams);
		insertStmt.sqlConnection = storage.tileSqlConnection;
		insertStmt.execute(-1, new Responder(resultHandler, errorHandler));

		storage.tileBitmapDataCache[tile.id] = tile.bitmapData;
	}

	private function tileToSQLParams(tile:Tile):Object {
		var res:Object = {};
		res.id = tile.id;
		res.bytes = tileBytes = Tile.encode(tile.bitmapData);
		return res;
	}

	private function needUpdate(tile:Tile):Boolean {
		return storage.tileBitmapDataCache[tile.id] && storage.tileBitmapDataCache[tile.id] != tile.bitmapData;
	}

	private function resultHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	private function errorHandler(error:SQLError):void {
		var errDetails:String = error.toString();
		CLog.info(LogTag.STORAGE, "SQL storing tiles is failed, error details: " + errDetails);
		if (total == 0) dispatchError();
	}

	override public function destroy():void {
		super.destroy();
		if (tileBytes) tileBytes.clear();
	}

}
}
