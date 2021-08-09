package de.dittner.testmyself.ui.view.noteList.components.form {
import de.dittner.testmyself.ui.common.tile.TileID;
import de.dittner.testmyself.ui.common.tile.TileShape;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.AppSizes;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.ui.view.form.components.FormMode;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

public class EditorBG extends UIComponent {
	public function EditorBG() {
		super();
		toolIcon = new TileShape();
		addChild(toolIcon);
	}

	private var toolIcon:TileShape;

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, Values.PT16, AppColors.TEXT_LIGHT);
	public static const HEADER_HEIGHT:uint = AppSizes.SCREEN_HEADER_HEIGHT;
	public static const PAD:uint = Values.PT15;
	public static const GAP:uint = Values.PT5;

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
	//  mode
	//--------------------------------------
	private var _mode:String = "add";
	[Inspectable(defaultValue="add", enumeration="add,edit,remove,filter,search")]
	[Bindable("modeChanged")]
	public function get mode():String {return _mode;}
	public function set mode(value:String):void {
		if (_mode != value) {
			_mode = value;
			createIcon();
			invalidateDisplayList();
			dispatchEvent(new Event("modeChanged"));
		}
	}

	//--------------------------------------
	//  bgColor
	//--------------------------------------
	private var _bgColor:uint = AppColors.APP_BG_WHITE;
	[Bindable("bgColorChanged")]
	public function get bgColor():uint {return _bgColor;}
	public function set bgColor(value:uint):void {
		if (_bgColor != value) {
			_bgColor = value;
			invalidateDisplayList();
			dispatchEvent(new Event("bgColorChanged"));
		}
	}

	private function createIcon():void {
		if (mode == FormMode.ADD) toolIcon.tileID = TileID.TOOLBAR_ADD_LIGHT;
		else if (mode == FormMode.EDIT) toolIcon.tileID = TileID.TOOLBAR_EDIT_LIGHT;
		else if (mode == FormMode.REMOVE) toolIcon.tileID = TileID.TOOLBAR_DELETE_LIGHT;
		else if (mode == FormMode.FILTER) toolIcon.tileID = TileID.TOOLBAR_FILTER_LIGHT;
	}

	public var titleTf:TextField;
	override protected function createChildren():void {
		titleTf = TextFieldFactory.create(TITLE_FORMAT);
		addChild(titleTf);

		createIcon();

		super.createChildren();
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		layoutContents(w, h);
		drawBackground(w, h);
	}

	private function layoutContents(w:Number, h:Number):void {
		var xOffset:Number = PAD;
		if (toolIcon) {
			toolIcon.x = xOffset;
			toolIcon.y = (HEADER_HEIGHT - toolIcon.height >> 1);
			xOffset += toolIcon.width + GAP;
		}
		titleTf.text = title;
		titleTf.x = xOffset;
		titleTf.y = (HEADER_HEIGHT - titleTf.textHeight >> 1) - 2;
		titleTf.width = w - titleTf.x;
	}

	private function drawBackground(w:Number, h:Number):void {
		var g:Graphics = graphics;
		g.clear();

		g.beginFill(bgColor);
		g.drawRect(0, 0, w, h);
		g.endFill();

		g.beginFill(0, 1);
		g.drawRect(0, 0, w, HEADER_HEIGHT);
		g.endFill();
	}
}
}
