package de.dittner.testmyself.ui.common.tileClasses {
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

[Event(name="change", type="flash.events.Event")]

public class FadeTileButton extends UIComponent {

	private const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, _fontSize, _textColor, _isBold);
	private static const DISABLED_BG_ALPHA:Number = 0.4;
	private static const UP_BG_ALPHA:Number = 0.6;

	public function FadeTileButton() {
		super();
		addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
	}

	private var upBg:TileShape;
	private var downBg:TileShape;
	private var disabledBg:TileShape;
	private var iconBg:TileShape;

	protected var titleTf:TextField;

	//--------------------------------------
	//  use9Scale
	//--------------------------------------
	private var _use9Scale:Boolean = false;
	[Bindable("use9ScaleChanged")]
	public function get use9Scale():Boolean {return _use9Scale;}
	public function set use9Scale(value:Boolean):void {
		if (_use9Scale != value) {
			_use9Scale = value;
			invalidateDisplayList();
			dispatchEvent(new Event("use9ScaleChanged"));
		}
	}

	//--------------------------------------
	//  upTileID
	//--------------------------------------
	private var _upTileID:String = "";
	[Bindable("upTileIDChanged")]
	public function get upTileID():String {return _upTileID;}
	public function set upTileID(value:String):void {
		if (_upTileID != value) {
			_upTileID = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("upTileIDChanged"));
		}
	}

	//--------------------------------------
	//  disabledTileID
	//--------------------------------------
	private var _disabledTileID:String = "";
	[Bindable("disabledTileIDTileIDChanged")]
	public function get disabledTileID():String {return _disabledTileID;}
	public function set disabledTileID(value:String):void {
		if (_disabledTileID != value) {
			_disabledTileID = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("disabledTileIDTileIDChanged"));
		}
	}

	//--------------------------------------
	//  downTileID
	//--------------------------------------
	private var _downTileID:String = "";
	[Bindable("downTileIDChanged")]
	public function get downTileID():String {return _downTileID;}
	public function set downTileID(value:String):void {
		if (_downTileID != value) {
			_downTileID = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("downTileIDChanged"));
		}
	}

	//--------------------------------------
	//  iconTileID
	//--------------------------------------
	private var _iconTileID:String = "";
	[Bindable("iconTileIDChanged")]
	public function get iconTileID():String {return _iconTileID;}
	public function set iconTileID(value:String):void {
		if (_iconTileID != value) {
			_iconTileID = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("iconTileIDChanged"));
		}
	}

	//--------------------------------------
	//  isToggle
	//--------------------------------------
	private var _isToggle:Boolean = false;
	[Bindable("isToggleChanged")]
	public function get isToggle():Boolean {return _isToggle;}
	public function set isToggle(value:Boolean):void {
		if (_isToggle != value) {
			_isToggle = value;
			updateBg();
			dispatchEvent(new Event("isToggleChanged"));
		}
	}

	//--------------------------------------
	//  selected
	//--------------------------------------
	private var denyInteractiveSelection:Boolean = false;
	private var _selected:Boolean = false;
	[Bindable(event='selectedChange')]
	public function get selected():Boolean {return _selected;}
	public function set selected(value:Boolean):void {
		if (_selected != value) {
			_selected = value;
			if (isDown) denyInteractiveSelection = true;
			updateBg();
			dispatchEvent(new Event("selectedChange"))
		}
	}

	//--------------------------------------
	//  deselectOnlyProgrammatically
	//--------------------------------------
	private var _deselectOnlyProgrammatically:Boolean = false;
	[Bindable("deselectOnlyProgrammaticallyChanged")]
	public function get deselectOnlyProgrammatically():Boolean {return _deselectOnlyProgrammatically;}
	public function set deselectOnlyProgrammatically(value:Boolean):void {
		if (_deselectOnlyProgrammatically != value) {
			_deselectOnlyProgrammatically = value;
			dispatchEvent(new Event("deselectOnlyProgrammaticallyChanged"));
		}
	}

	override public function set enabled(value:Boolean):void {
		if (super.enabled != value) {
			super.enabled = value;
			super.mouseEnabled = enabled && _mouseEnabled;
			super.mouseChildren = enabled && _mouseChildren;
			updateBg();
		}
	}

	private var _mouseEnabled:Boolean = true;
	override public function set mouseEnabled(value:Boolean):void {
		if (_mouseEnabled != value) {
			_mouseEnabled = value;
			super.mouseEnabled = enabled && _mouseEnabled;
		}
	}

	private var _mouseChildren:Boolean = true;
	override public function set mouseChildren(value:Boolean):void {
		if (_mouseChildren != value) {
			_mouseChildren = value;
			super.mouseChildren = enabled && _mouseChildren;
		}
	}

	[PercentProxy("percentHeight")]
	[Inspectable(category="General")]
	[Bindable("heightChanged")]
	override public function get height():Number {
		return super.height ? super.height : measuredHeight;
	}

	[PercentProxy("percentWidth")]
	[Inspectable(category="General")]
	[Bindable("widthChanged")]
	override public function get width():Number {
		return super.width ? super.width : measuredWidth;
	}

	//--------------------------------------
	//  paddingLeft
	//--------------------------------------
	private var _paddingLeft:Number = Values.PT30;
	[Bindable("paddingLeftChanged")]
	public function get paddingLeft():Number {return _paddingLeft;}
	public function set paddingLeft(value:Number):void {
		if (_paddingLeft != value) {
			_paddingLeft = value;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("paddingLeftChanged"));
		}
	}

	//--------------------------------------
	//  paddingRight
	//--------------------------------------
	private var _paddingRight:Number = Values.PT30;
	[Bindable("paddingRightChanged")]
	public function get paddingRight():Number {return _paddingRight;}
	public function set paddingRight(value:Number):void {
		if (_paddingRight != value) {
			_paddingRight = value;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("paddingRightChanged"));
		}
	}

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String = "";
	[Bindable("titleChanged")]
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_title != value) {
			_title = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("titleChanged"));
		}
	}

	//--------------------------------------
	//  fontSize
	//--------------------------------------
	private var _fontSize:Number = Values.PT15;
	[Bindable("fontSizeChanged")]
	public function get fontSize():Number {return _fontSize;}
	public function set fontSize(value:Number):void {
		if (_fontSize != value) {
			_fontSize = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("fontSizeChanged"));
		}
	}

	//--------------------------------------
	//  isBold
	//--------------------------------------
	private var _isBold:Boolean = false;
	[Bindable("isBoldChanged")]
	public function get isBold():Boolean {return _isBold;}
	public function set isBold(value:Boolean):void {
		if (_isBold != value) {
			_isBold = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("isBoldChanged"));
		}
	}

	//--------------------------------------
	//  textColor
	//--------------------------------------
	private var _textColor:uint = 0x565656;
	[Bindable("textColorChanged")]
	public function get textColor():uint {return _textColor;}
	public function set textColor(value:uint):void {
		if (_textColor != value) {
			_textColor = value;
			invalidateProperties();
			dispatchEvent(new Event("textColorChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();
		if (!upBg) {
			upBg = new TileShape();
			upBg.alphaTo = UP_BG_ALPHA;
			addChild(upBg);
		}
		if (!downBg) {
			downBg = new TileShape();
			downBg.alphaTo = 0;
			addChild(downBg);
		}

		if (!disabledBg) {
			disabledBg = new TileShape();
			disabledBg.alphaTo = 0;
			addChild(disabledBg);
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();
		upBg.tileID = upTileID;
		downBg.tileID = downTileID;
		disabledBg.tileID = disabledTileID;

		if (iconTileID && !iconBg) {
			iconBg = new TileShape(iconTileID);
			addChild(iconBg);
		}

		if (title && !titleTf) {
			titleTf = TextFieldFactory.create(TITLE_FORMAT);
			addChild(titleTf);
		}

		if (titleTf) {
			TITLE_FORMAT.size = fontSize;
			TITLE_FORMAT.bold = isBold;
			TITLE_FORMAT.color = textColor;
			titleTf.defaultTextFormat = TITLE_FORMAT;
			titleTf.text = title;
		}
	}

	override protected function measure():void {
		super.measure();
		measuredWidth = titleTf && titleTf.text ? titleTf.textWidth + paddingLeft + paddingRight : upBg.width;
		measuredHeight = upBg.height;
	}

	override public function validateDisplayList():void {
		oldLayoutDirection = layoutDirection;
		if (invalidateDisplayListFlag) {
			setActualSize(width || measuredWidth, height || measuredHeight);
			validateMatrix();

			var unscaledWidth:Number = width || measuredWidth;
			var unscaledHeight:Number = height || measuredHeight;

			updateDisplayList(unscaledWidth, unscaledHeight);
			invalidateDisplayListFlag = false;
		}
		else {
			validateMatrix();
		}
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		alpha = enabled || disabledTileID ? 1 : DISABLED_BG_ALPHA;

		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 0.0000001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		if (w != 0 && h != 0) {
			if (titleTf) {
				titleTf.x = w - titleTf.textWidth >> 1;
				titleTf.y = (h - titleTf.textHeight >> 1) - Values.PT2;
				titleTf.width = w - titleTf.x;
				titleTf.height = h - titleTf.y;
			}

			if (iconBg) {
				iconBg.x = paddingLeft;
				iconBg.y = h - iconBg.height >> 1;
			}

			if (!use9Scale) {
				w = NaN;
				h = NaN;
			}
			upBg.width = w;
			downBg.width = w;
			disabledBg.width = w;

			upBg.height = h;
			downBg.height = h;
			disabledBg.height = h;
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Handlers
	//
	//----------------------------------------------------------------------------------------------

	private var isDown:Boolean = false;

	protected function mouseUpHandler(event:MouseEvent):void {
		if (isDown && isToggle) {
			isDown = false;
			if (denyInteractiveSelection) {
				denyInteractiveSelection = false;
			}
			else {
				var oldSelected:Boolean = selected;
				selected = selected ? deselectOnlyProgrammatically : true;
				if (selected != oldSelected)
					dispatchEvent(new Event(Event.CHANGE));
			}
		}

		if (upBg)
			upBg.alphaTo = enabled && !(isToggle && selected) ? 1 : UP_BG_ALPHA;

		if (downBg)
			downBg.alphaTo = isToggle && selected ? 1 : 0;

		if (disabledBg)
			disabledBg.alphaTo = enabled ? 0 : 1;
	}

	protected function mouseOverHandler(event:MouseEvent):void {
		if (upBg)
			upBg.alphaTo = enabled && !(isToggle && selected) ? 1 : UP_BG_ALPHA;

		if (downBg)
			downBg.alphaTo = isToggle && selected ? 1 : 0;

		if (disabledBg)
			disabledBg.alphaTo = enabled ? 0 : 1;
	}

	protected function mouseDownHandler(event:MouseEvent):void {
		isDown = true;

		if (upBg)
			upBg.alphaTo = UP_BG_ALPHA;

		if (downBg)
			downBg.alphaTo = enabled || (isToggle && selected) ? 1 : 0;

		if (disabledBg)
			disabledBg.alphaTo = enabled ? 0 : 1;
	}

	protected function mouseOutHandler(event:MouseEvent):void {
		isDown = false;

		if (upBg)
			upBg.alphaTo = UP_BG_ALPHA;

		if (downBg)
			downBg.alphaTo = isToggle && selected ? 1 : 0;

		if (disabledBg)
			disabledBg.alphaTo = enabled ? 0 : 1;
	}

	protected function updateBg():void {
		if (upBg)
			upBg.alphaTo = UP_BG_ALPHA;

		if (downBg)
			downBg.alphaTo = isToggle && selected ? 1 : 0;

		if (disabledBg)
			disabledBg.alphaTo = enabled ? 0 : 1;
	}

}
}
