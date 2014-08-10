package dittner.testmyself.view.common.editor {
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;
import dittner.testmyself.view.common.utils.TextFieldFactory;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

public class EditorBg extends UIComponent {
	public function EditorBg() {
		super();
	}

	[Embed(source='/assets/tools/add_light.png')]
	private static const AddIconClass:Class;
	[Embed(source='/assets/tools/edit_light.png')]
	private static const EditIconClass:Class;
	[Embed(source='/assets/tools/recycle_bin_light.png')]
	private static const RemoveIconClass:Class;

	private var toolIcon:Bitmap;

	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.VERDANAMX, 14, AppColors.TEXT_LIGHT, true);
	public static const HEADER_HEIGHT:uint = 40;
	public static const PAD:uint = 20;
	public static const VOFFSET:uint = 10;
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
	//  mode
	//--------------------------------------
	private var _mode:String = "add";
	[Inspectable(defaultValue="add", enumeration="add,edit,remove")]
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

	private function createIcon():void {
		if (toolIcon) removeChild(toolIcon);
		if (mode == "add") toolIcon = new AddIconClass();
		else if (mode == "edit") toolIcon = new EditIconClass();
		else if (mode == "remove") toolIcon = new RemoveIconClass();
		if (toolIcon) addChild(toolIcon);
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
			toolIcon.y = (HEADER_HEIGHT + VOFFSET - toolIcon.height >> 1);
			xOffset += toolIcon.width + 5;
		}
		titleTf.text = title;
		titleTf.x = xOffset - 2;
		titleTf.y = (HEADER_HEIGHT + VOFFSET - titleTf.textHeight >> 1) - 2;
		titleTf.width = w - 2 * titleTf.x;
	}

	private function drawBackground(w:Number, h:Number):void {
		var g:Graphics = graphics;
		g.clear();

		g.beginFill(AppColors.EDITOR_BORDER, 1);
		g.drawRect(0, VOFFSET, w, h-VOFFSET);
		g.endFill();

		g.beginFill(AppColors.EDITOR_CONTENT_BG, 1);
		g.drawRect(BORDER_THICKNESS, HEADER_HEIGHT, w - 2 * BORDER_THICKNESS, h - HEADER_HEIGHT - BORDER_THICKNESS);
		g.endFill();
	}
}
}