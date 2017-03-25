package de.dittner.testmyself.ui.common.tile {
import flash.events.MouseEvent;

public class TileButton extends TileImage {
	public function TileButton() {
		super();
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
	}

	protected var isDown:Boolean = false;

	//--------------------------------------
	//  upTileID
	//--------------------------------------
	protected var _upTileID:String = "";
	public function get upTileID():String {return _upTileID;}
	public function set upTileID(value:String):void {
		if (_upTileID != value) {
			_upTileID = value;
			updateActualTileID();
		}
	}

	//--------------------------------------
	//  downTileID
	//--------------------------------------
	protected var _downTileID:String = "";
	public function get downTileID():String {return _downTileID;}
	public function set downTileID(value:String):void {
		if (_downTileID != value) {
			_downTileID = value;
			updateActualTileID();
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	protected function mouseDownHandler(event:MouseEvent):void {
		if (!isDown) {
			isDown = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			updateActualTileID();
		}
	}

	protected function mouseUpHandler(event:MouseEvent):void {
		if (isDown) {
			isDown = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			updateActualTileID();
		}
	}

	protected function updateActualTileID():void {
		if (upTileID && !isDown) actualTileID = upTileID;
		else if (downTileID && isDown) actualTileID = downTileID;
	}
}
}
