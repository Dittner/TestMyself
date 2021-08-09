package de.dittner.testmyself.backend.tileStorage {
public class TileSQLLib {
	public function TileSQLLib() {}


	[Embed(source="/de/dittner/testmyself/backend/tileStorage/sql/CreateTileTbl.sql", mimeType="application/octet-stream")]
	private static const CreateTileTblClass:Class;
	public static const CREATE_TILE_TBL:String = new CreateTileTblClass();

	[Embed(source="/de/dittner/testmyself/backend/tileStorage/sql/SelectAllTiles.sql", mimeType="application/octet-stream")]
	private static const SelectAllTilesClass:Class;
	public static const SELECT_ALL_TILES:String = new SelectAllTilesClass();

	[Embed(source="/de/dittner/testmyself/backend/tileStorage/sql/InsertTile.sql", mimeType="application/octet-stream")]
	private static const InsertTileClass:Class;
	public static const INSERT_TILE:String = new InsertTileClass();

	[Embed(source="/de/dittner/testmyself/backend/tileStorage/sql/UpdateTile.sql", mimeType="application/octet-stream")]
	private static const UpdateTileClass:Class;
	public static const UPDATE_TILE:String = new UpdateTileClass();

}
}
