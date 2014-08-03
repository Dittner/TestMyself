package dittner.testmyself.view.common.editor {
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;
import dittner.testmyself.view.common.utils.TextFieldFactory;

import flash.display.Graphics;
import flash.events.Event;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

public class EditorBg extends UIComponent {
	public function EditorBg() {
		super();
	}

	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.VERDANAMX, 16, AppColors.TEXT_GRAY_LIGHT);
	public static const HEADER_HEIGHT:uint = 40;
	private static const ARROW_SIZE:uint = 10;
	public static const PADDING:uint = 20;
	public static const BORDER_THICKNESS:uint = 5;

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String = "";
	[Bindable("titleChanged")]
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_title != value) {
			_title = value;
			invalidateDisplayList();
			dispatchEvent(new Event("titleChanged"));
		}
	}

	//--------------------------------------
	//  arrowPos
	//--------------------------------------
	private var _arrowPos:Point;
	[Bindable("arrowPosChanged")]
	public function get arrowPos():Point {return _arrowPos;}
	public function set arrowPos(value:Point):void {
		if (_arrowPos != value) {
			_arrowPos = value;
			invalidateDisplayList();
			dispatchEvent(new Event("arrowPosChanged"));
		}
	}

	public var titleTf:TextField;
	override protected function createChildren():void {
		titleTf = TextFieldFactory.create(TITLE_FORMAT);
		addChild(titleTf);

		super.createChildren();
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		layoutContents(w, h);
		drawBackground(w, h);
	}
	private function layoutContents(w:Number, h:Number):void {
		titleTf.text = title;
		titleTf.x = PADDING - 2;
		titleTf.y = (HEADER_HEIGHT - titleTf.textHeight + 5) / 2;
		titleTf.width = w - 2 * titleTf.x;
	}

	private function drawBackground(w:Number, h:Number):void {
		var g:Graphics = graphics;
		g.clear();

		g.beginFill(AppColors.EDITOR_BORDER, 1);
		g.drawRect(0, ARROW_SIZE, w, h - ARROW_SIZE);
		g.endFill();

		g.beginFill(AppColors.EDITOR_CONTENT_BG, 1);
		g.drawRect(BORDER_THICKNESS, HEADER_HEIGHT, w - 2 * BORDER_THICKNESS, h - HEADER_HEIGHT - BORDER_THICKNESS);
		g.endFill();

		//arrow
		var arrowPosX:Number = arrowPos ? arrowPos.x : w / 2;
		g.lineStyle();
		g.beginFill(AppColors.EDITOR_BORDER, 1);
		g.moveTo(arrowPosX - ARROW_SIZE / 2, ARROW_SIZE);
		g.lineTo(arrowPosX, 0);
		g.lineTo(arrowPosX + ARROW_SIZE / 2, ARROW_SIZE);
		g.moveTo(arrowPosX - ARROW_SIZE / 2, ARROW_SIZE);
		g.endFill();

	}
}
}
