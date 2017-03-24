package de.dittner.testmyself.backend.tileStorage.cmd {
import de.dittner.async.AsyncCommand;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.tileStorage.TileSQLLib;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.ui.common.tileClasses.Tile;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.ByteArray;

public class LoadAllTilesCmd extends AsyncCommand {

	public function LoadAllTilesCmd(storage:Storage) {
		super();
		this.storage = storage;
	}

	private var storage:Storage;

	override public function execute():void {
		var insertStmt:SQLStatement = SQLUtils.createSQLStatement(TileSQLLib.SELECT_ALL_TILES, {});
		insertStmt.sqlConnection = storage.tileSqlConnection;
		insertStmt.execute(-1, new Responder(resultHandler, errorHandler));
	}

	private function resultHandler(result:SQLResult):void {
		var bytes:ByteArray;
		try {
			if (result && result.data) {
				for each(var item:Object in result.data) {
					bytes = item.bytes;
					storage.tileBitmapDataCache[item.id] = Tile.decode(bytes);
					bytes.clear();
				}
			}
			else {
				storage.hasTiles = false;
			}
		}
		catch (e:Error) {
			CLog.err(LogTag.UI, "Tiles decoding is failed! Details: " + e.toString());
		}
		dispatchSuccess();
	}

	private function errorHandler(error:SQLError):void {
		CLog.err(LogTag.UI, "Load of all tiles is failed! Details: " + error.message);
		dispatchError(error);
	}

}
}
