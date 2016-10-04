package de.dittner.testmyself.ui.common.button {
import flash.display.DisplayObject;
import flash.events.MouseEvent;

import mx.events.FlexEvent;

import spark.core.SpriteVisualElement;

[Event(name="click", type="flash.events.MouseEvent")]
[Event(name="show", type="mx.events.FlexEvent")]
[Event(name="hide", type="mx.events.FlexEvent")]
public class SpriteButton extends SpriteVisualElement {
	public function SpriteButton() {
		super();
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
	}

	protected var isDown:Boolean = false;
	protected var upState:DisplayObject;
	protected var downState:DisplayObject;
	protected var disabledState:DisplayObject;

	//--------------------------------------
	//  upStateClass
	//--------------------------------------
	protected var _upStateClass:Class;
	public function get upStateClass():Class {return _upStateClass;}
	public function set upStateClass(value:Class):void {
		if (_upStateClass != value) {
			if (upState) {
				removeChild(upState);
				upState = null;
			}
			_upStateClass = value;
			if (upStateClass) {
				upState = new upStateClass();
				addChildAt(upState, 0);
			}
			redraw();
		}
	}

	public function get measuredWidth():Number {
		return upState ? upState.width : 0;
	}

	public function get measuredHeight():Number {
		return upState ? upState.height : 0;
	}

	//--------------------------------------
	//  downStateClass
	//--------------------------------------
	protected var _downStateClass:Class;
	public function get downStateClass():Class {return _downStateClass;}
	public function set downStateClass(value:Class):void {
		if (_downStateClass != value) {
			if (downState) {
				removeChild(downState);
				downState = null;
			}
			_downStateClass = value;
			if (downStateClass) {
				downState = new downStateClass();
				addChildAt(downState, 0);
			}
			redraw();
		}
	}

	//--------------------------------------
	//  disabledStateClass
	//--------------------------------------
	protected var _disabledStateClass:Class;
	public function get disabledStateClass():Class {return _disabledStateClass;}
	public function set disabledStateClass(value:Class):void {
		if (_disabledStateClass != value) {
			if (!enabled) {
				removeChild(disabledState);
				disabledState = null;
			}
			_disabledStateClass = value;
			if (disabledStateClass) {
				disabledState = new disabledStateClass();
				addChildAt(disabledState, 0);
			}
			redraw();
		}
	}

	//--------------------------------------
	//  enabled
	//--------------------------------------
	protected var _enabled:Boolean = true;
	public function get enabled():Boolean {return _enabled;}
	public function set enabled(value:Boolean):void {
		if (_enabled != value) {
			_enabled = value;
			mouseEnabled = enabled;
			redraw();
		}
	}

	override public function set visible(value:Boolean):void {
		if (visible != value) {
			super.visible = value;
			dispatchEvent(new FlexEvent(visible ? FlexEvent.SHOW : FlexEvent.HIDE));
		}
	}

	//--------------------------------------
	//  methods
	//--------------------------------------
	protected function mouseDownHandler(event:MouseEvent):void {
		if (!isDown) {
			isDown = true;
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			redraw();
		}
	}

	protected function mouseUpHandler(event:MouseEvent):void {
		if (isDown) {
			isDown = false;
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			redraw();
		}
	}

	protected function redraw():void {
		if (disabledState) disabledState.visible = !enabled;
		if (upState) upState.visible = !isDown && enabled;
		if (downState) downState.visible = isDown && enabled;
	}

	[Bindable(event='sizeChanged')]
	override public function get width():Number {return super.width || measuredWidth;}
	[Bindable(event='sizeChanged')]
	override public function get height():Number {return super.height || measuredHeight;}

}
}
