package de.dittner.testmyself.ui.common.tile {
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

[Event(name="click", type="flash.events.MouseEvent")]

public class TitleTileButton extends TileButton {
	public function TitleTileButton() {
		super();
		use9Scale = true;
	}

	private const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, _fontSize, _textColor, _isBold);
	protected var titleTf:TextField;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

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
	private var _fontSize:Number = Values.PT17;
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
		if (!titleTf) {
			titleTf = TextFieldFactory.create(TITLE_FORMAT);
			addChild(titleTf);
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();
		TITLE_FORMAT.size = fontSize;
		TITLE_FORMAT.bold = isBold;
		TITLE_FORMAT.color = textColor;
		titleTf.defaultTextFormat = TITLE_FORMAT;
		titleTf.text = title;
	}

	override protected function measure():void {
		super.measure();
		measuredWidth = titleTf.textWidth + paddingLeft + paddingRight;
		measuredHeight = Math.max(titleTf.textHeight, bg.height - 2 * shadowSize);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		titleTf.x = w - titleTf.textWidth >> 1;
		titleTf.y = (h - titleTf.textHeight >> 1) - Values.PT2;
	}

}
}
