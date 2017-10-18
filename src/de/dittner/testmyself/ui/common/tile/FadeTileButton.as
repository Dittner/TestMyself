package de.dittner.testmyself.ui.common.tile {
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import mx.core.UIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

[Event(name="change", type="flash.events.Event")]
[Event(name="selectedChange", type="flash.events.Event")]

public class FadeTileButton extends UIComponent {
	protected const TITLE_FORMAT:TextFormat = new TextFormat(_font, _fontSize, _textColor, _isBold, _isItalic, null, null, null, TextAlign.CENTER);

	public function FadeTileButton() {
		super();
		addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
	}

	protected var upBg:TileShape;
	protected var downBg:TileShape;
	protected var disabledBg:TileShape;
	protected var iconBg:TileShape;

	protected var titleTf:FadeTextField;

	//--------------------------------------
	//  upBgAlpha
	//--------------------------------------
	private var _upBgAlpha:Number = 0.6;
	[Bindable("upBgAlphaChanged")]
	public function get upBgAlpha():Number {return _upBgAlpha;}
	public function set upBgAlpha(value:Number):void {
		if (_upBgAlpha != value) {
			_upBgAlpha = value;
			invalidateDisplayList();
			dispatchEvent(new Event("upBgAlphaChanged"));
		}
	}

	//--------------------------------------
	//  disabledBgAlpha
	//--------------------------------------
	private var _disabledBgAlpha:Number = 0.3;
	[Bindable("disabledBgAlphaChanged")]
	public function get disabledBgAlpha():Number {return _disabledBgAlpha;}
	public function set disabledBgAlpha(value:Number):void {
		if (_disabledBgAlpha != value) {
			_disabledBgAlpha = value;
			invalidateDisplayList();
			dispatchEvent(new Event("disabledBgAlphaChanged"));
		}
	}

	//--------------------------------------
	//  animationDuration
	//--------------------------------------
	private var _animationDuration:Number = 0.4;
	[Bindable("animationDurationChanged")]
	public function get animationDuration():Number {return _animationDuration;}
	public function set animationDuration(value:Number):void {
		if (_animationDuration != value) {
			_animationDuration = value;
			invalidateProperties();
			dispatchEvent(new Event("animationDurationChanged"));
		}
	}

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
			invalidateDisplayList();
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
			invalidateDisplayList();
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
			super.mouseEnabled = _mouseEnabled && super.enabled;
			invalidateDisplayList();
		}
	}

	//--------------------------------------
	//  mouseEnabled
	//--------------------------------------
	private var _mouseEnabled:Boolean = true;
	[Bindable("mouseEnabledChanged")]
	override public function get mouseEnabled():Boolean {return _mouseEnabled;}
	override public function set mouseEnabled(value:Boolean):void {
		if (_mouseEnabled != value) {
			_mouseEnabled = value;
			super.mouseEnabled = _mouseEnabled && super.enabled;
			dispatchEvent(new Event("mouseEnabledChanged"));
		}
	}

	//--------------------------------------
	//  mouseChildren
	//--------------------------------------
	private var _mouseChildren:Boolean = true;
	[Bindable("mouseChildrenChanged")]
	override public function get mouseChildren():Boolean {return _mouseChildren;}
	override public function set mouseChildren(value:Boolean):void {
		if (_mouseChildren != value) {
			_mouseChildren = value;
			super.mouseChildren = _mouseChildren;
			dispatchEvent(new Event("mouseChildrenChanged"));
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
			_title = value || "";
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("titleChanged"));
		}
	}

	//--------------------------------------
	//  font
	//--------------------------------------
	private var _font:String = FontName.BASIC_MX;
	[Bindable("fontChanged")]
	public function get font():String {return _font;}
	public function set font(value:String):void {
		if (_font != value) {
			_font = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("fontChanged"));
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
	//  isItalic
	//--------------------------------------
	private var _isItalic:Boolean = false;
	[Bindable("isItalicChanged")]
	public function get isItalic():Boolean {return _isItalic;}
	public function set isItalic(value:Boolean):void {
		if (_isItalic != value) {
			_isItalic = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("isItalicChanged"));
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
			upBg.alphaTo = upBgAlpha;
			addChild(upBg);
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();
		upBg.tileID = upTileID;
		upBg.animationDuration = animationDuration;

		if (downTileID && !downBg) {
			downBg = new TileShape();
			downBg.alphaTo = 0;
			addChild(downBg);
		}

		if (disabledTileID && !disabledBg) {
			disabledBg = new TileShape();
			disabledBg.alphaTo = 0;
			addChild(disabledBg);
		}

		if (downBg) {
			downBg.tileID = downTileID;
			downBg.animationDuration = animationDuration;
		}

		if (disabledBg) {
			disabledBg.tileID = disabledTileID;
			disabledBg.animationDuration = animationDuration;
		}

		if (iconTileID && !iconBg) {
			iconBg = new TileShape(iconTileID);
			addChild(iconBg);
		}
		if (iconBg) iconBg.tileID = iconTileID;

		if (title && !titleTf) {
			titleTf = TextFieldFactory.createFadeTextField(TITLE_FORMAT);
			addChild(titleTf);
		}

		if (titleTf) {
			TITLE_FORMAT.font = font;
			TITLE_FORMAT.size = fontSize;
			TITLE_FORMAT.bold = isBold;
			TITLE_FORMAT.italic = isItalic;
			TITLE_FORMAT.color = textColor;
			titleTf.defaultTextFormat = TITLE_FORMAT;
			titleTf.text = title;
		}
	}

	override protected function measure():void {
		super.measure();
		measuredWidth = !use9Scale ? upBg.measuredWidth : 0;
		measuredWidth = titleTf && titleTf.text ? Math.max(measuredWidth, (titleTf.textWidth + paddingLeft + paddingRight)) : upBg.measuredWidth;
		if (iconBg) measuredWidth += 2 * (iconBg.width + Values.PT5 + paddingLeft);
		measuredHeight = upBg.measuredHeight;
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

		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 0.0000001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		if (w > 0 && h > 0) {
			if (iconBg) {
				iconBg.x = paddingLeft;
				iconBg.y = h - iconBg.height >> 1;
			}

			if (titleTf) {
				titleTf.x = iconBg ? iconBg.x + iconBg.width + Values.PT5 : paddingLeft - Values.PT2;
				titleTf.y = Math.ceil(h - titleTf.textHeight >> 1) - 1;
				titleTf.width = iconBg ? w - 2 * titleTf.x : w - titleTf.x - paddingRight + Values.PT2;
				titleTf.height = h - titleTf.y;
			}

			if (!use9Scale) {
				w = NaN;
				h = NaN;
			}

			upBg.width = w;
			if (downBg) downBg.width = w;
			if (disabledBg) disabledBg.width = w;

			upBg.height = h;
			if (downBg) downBg.height = h;
			if (disabledBg) disabledBg.height = h;

			redrawBg();
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Handlers
	//
	//----------------------------------------------------------------------------------------------

	protected var isDown:Boolean = false;
	protected var isHover:Boolean = false;

	private function mouseUpHandler(event:MouseEvent):void {
		if (isDown) {
			isDown = false;

			if (isToggle && enabled) {
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
			redrawBg();
		}
	}

	private function mouseOverHandler(event:MouseEvent):void {
		isHover = true;
		redrawBg();
	}

	private function mouseDownHandler(event:MouseEvent):void {
		isDown = true;
		redrawBg();
	}

	private function mouseOutHandler(event:MouseEvent):void {
		isHover = false;
		isDown = false;
		redrawBg();
	}

	protected function redrawBg():void {
		if(isDown && enabled) {
			if (upBg)
				upBg.alphaTo = 1;

			if (downBg)
				downBg.alphaTo = 1;

			if (disabledBg)
				disabledBg.alphaTo = 0;
		}
		else if(isHover && enabled){
			if (upBg)
				upBg.alphaTo = Device.isDesktop || (isToggle && selected) ? 1 : upBgAlpha;

			if (downBg)
				downBg.alphaTo = isToggle && selected ? 1 : 0;

			if (disabledBg)
				disabledBg.alphaTo = 0;
		}
		else {
			if (upBg)
				upBg.alphaTo = enabled ? (isToggle && selected) ? 1 : upBgAlpha : disabledBgAlpha;

			if (downBg)
				downBg.alphaTo = isToggle && selected ? enabled ? 1 : disabledBgAlpha : 0;

			if (disabledBg)
				disabledBg.alphaTo = enabled ? 0 : 1;
		}
	}

}
}
