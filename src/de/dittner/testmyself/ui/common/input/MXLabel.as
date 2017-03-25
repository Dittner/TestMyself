package de.dittner.testmyself.ui.common.input {
import de.dittner.async.utils.invalidateOf;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.events.FlexEvent;

import spark.core.SpriteVisualElement;

[Event(name="click", type="flash.events.MouseEvent")]

public class MXLabel extends SpriteVisualElement {
	public function MXLabel() {
		super();
		tf = TextFieldFactory.create(titleFormat);
		addChild(tf);
	}

	private static const titleFormat:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT15, AppColors.TEXT_CONTROL_TITLE);
	private var tf:TextField;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  horPadding
	//--------------------------------------
	private var _horPadding:Number = 0;
	[Bindable("horPaddingChanged")]
	public function get horPadding():Number {return _horPadding;}
	public function set horPadding(value:Number):void {
		if (_horPadding != value) {
			_horPadding = value;
			invalidateOf(redraw);
			dispatchEvent(new Event("horPaddingChanged"));
		}
	}

	//--------------------------------------
	//  text
	//--------------------------------------
	private var _text:String = "";
	[Bindable("textChanged")]
	public function get text():String {return _text;}
	public function set text(value:String):void {
		if (_text != value) {
			_text = value;
			invalidateOf(redraw);
			dispatchEvent(new Event("textChanged"));
		}
	}

	//--------------------------------------
	//  fontSize
	//--------------------------------------
	private var _fontSize:Number = 15;
	[Bindable("fontSizeChanged")]
	public function get fontSize():Number {return _fontSize;}
	public function set fontSize(value:Number):void {
		if (_fontSize != value) {
			_fontSize = value;
			invalidateOf(redraw);
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
			invalidateOf(redraw);
			dispatchEvent(new Event("isBoldChanged"));
		}
	}

	//--------------------------------------
	//  color
	//--------------------------------------
	private var _color:uint = AppColors.TEXT_CONTROL_TITLE;
	[Bindable("colorChanged")]
	public function get color():uint {return _color;}
	public function set color(value:uint):void {
		if (_color != value) {
			_color = value;
			tf.textColor = color;
			dispatchEvent(new Event("colorChanged"));
		}
	}

	//--------------------------------------
	//  textColor
	//--------------------------------------
	protected var _measuredWidth:Number = 0;
	public function get measuredWidth():Number {return _measuredWidth;}

	//--------------------------------------
	//  textColor
	//--------------------------------------
	protected var _measuredHeight:Number = 0;
	public function get measuredHeight():Number {return _measuredHeight;}

	//--------------------------------------
	//  textColor
	//--------------------------------------
	private var explicitWidth:Number = 0;
	[Bindable(event='sizeChanged')]
	override public function get width():Number {return explicitWidth || measuredWidth;}
	override public function set width(value:Number):void {
		if (explicitWidth != value) {
			explicitWidth = value;
			dispatchEvent(new Event("sizeChanged"));
			invalidateOf(redraw);
		}
	}

	//--------------------------------------
	//  textColor
	//--------------------------------------
	private var explicitHeight:Number = 0;
	[Bindable(event='sizeChanged')]
	override public function get height():Number {return explicitHeight || measuredHeight;}
	override public function set height(value:Number):void {
		if (explicitHeight != value) {
			explicitHeight = value;
			dispatchEvent(new Event("sizeChanged"));
			invalidateOf(redraw);
		}
	}

	override public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle {
		return new Rectangle(0, 0, measuredWidth, measuredHeight);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function redraw():void {
		tf.defaultTextFormat = new TextFormat(FontName.MYRIAD_MX, fontSize, color, isBold);
		tf.text = text;
		tf.x = -2;
		_measuredWidth = tf.textWidth + 2 * horPadding;
		_measuredHeight = tf.textHeight;
		invalidateSize();
	}

	override public function set visible(value:Boolean):void {
		if (visible != value) {
			super.visible = value;
			dispatchEvent(new FlexEvent(visible ? FlexEvent.SHOW : FlexEvent.HIDE));
		}
	}
}
}
