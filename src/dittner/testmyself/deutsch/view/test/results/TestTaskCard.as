package dittner.testmyself.deutsch.view.test.results {
import dittner.testmyself.deutsch.view.common.utils.Fonts;
import dittner.testmyself.deutsch.view.common.utils.TextFieldFactory;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

public class TestTaskCard extends Sprite {

	private static const GAP:uint = 10;
	private static const HEI:uint = 16;
	private static const WID:uint = 75;
	private static const FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_COND_MX, 12, 0xffFFff);
	private var labelTF:TextField;

	public function TestTaskCard() {
		super();
		createElements();
		measure();
		updateDisplay();
	}

	//--------------------------------------
	//  label
	//--------------------------------------
	private var _label:String = "";
	public function get label():String {return _label;}
	public function set label(value:String):void {
		if (_label != value) {
			_label = value;
			labelTF.text = label;
			measure();
			updateDisplay();
		}
	}

	//--------------------------------------
	//  width
	//--------------------------------------
	private var _width:Number = 0;
	override public function get width():Number {return _width;}
	override public function set width(value:Number):void {
		if (_width != value) {
			_width = value;
		}
	}

	//--------------------------------------
	//  height
	//--------------------------------------
	private var _height:Number = 0;
	override public function get height():Number {return _height;}
	override public function set height(value:Number):void {
		if (_height != value) {
			_height = value;
		}
	}

	protected function createElements():void {
		labelTF = TextFieldFactory.create(FORMAT, false);
		labelTF.text = label;
		addChild(labelTF);
	}

	public function measure():void {
		width = Math.max(GAP + labelTF.textWidth + GAP, WID);
		height = HEI;
	}

	public function updateDisplay():void {
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0x676772);
		g.drawRect(0, 0, width, height);
		g.endFill();

		labelTF.x = (width - labelTF.textWidth >> 1) - 3;
		labelTF.y = (height - labelTF.textHeight >> 1) - 3;
		labelTF.width = labelTF.textWidth + 5;
	}
}
}
