package dittner.testmyself.view.core {
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.utils.AppColors;
import dittner.testmyself.view.utils.FontName;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import org.osmf.layout.VerticalAlign;

import spark.layouts.HorizontalAlign;
import spark.layouts.HorizontalLayout;
import spark.skins.mobile.SkinnableContainerSkin;

public class ViewBaseSkin extends SkinnableContainerSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.HELVETICA_NEUE_ULTRALIGHT, 24, 0x4e4f61);
	private static const PADDING:uint = 20;

	public function ViewBaseSkin() {
		super();
	}

	public var toolPanel:SelectableDataGroup;

	//--------------------------------------
	//  hostView
	//--------------------------------------

	public function get hostView():ViewBase {return hostComponent as ViewBase}

	public var titleTf:TextField;
	override protected function createChildren():void {
		titleTf = createTextField();
		titleTf.defaultTextFormat = TITLE_FORMAT;
		addChild(titleTf);

		super.createChildren();
		contentGroup.left = contentGroup.right = contentGroup.top = contentGroup.bottom = PADDING;

		toolPanel = new SelectableDataGroup();
		toolPanel.id = "toolPanel";
		var hLayout:HorizontalLayout = new HorizontalLayout();
		hLayout.gap = 0;
		hLayout.useVirtualLayout = false;
		hLayout.paddingLeft = PADDING;
		hLayout.paddingRight = PADDING;
		hLayout.verticalAlign = VerticalAlign.MIDDLE;
		hLayout.horizontalAlign = HorizontalAlign.CONTENT_JUSTIFY;
		toolPanel.layout = hLayout;
		addChild(toolPanel);
	}

	protected static function createTextField():TextField {
		var textField:TextField = new TextField();
		textField.selectable = false;
		textField.multiline = false;
		textField.wordWrap = false;
		textField.mouseEnabled = false;
		textField.mouseWheelEnabled = false;
		return textField;
	}

	override protected function layoutContents(w:Number, h:Number):void {
		super.layoutContents(w, h);
		toolPanel.x = w - toolPanel.measuredWidth - PADDING;
		toolPanel.width = toolPanel.measuredWidth;
		toolPanel.height = hostView.headerHeight;

		updateTitleText();
		titleTf.x = PADDING * 2;
		titleTf.y = (hostView.headerHeight - titleTf.textHeight - 5) / 2;
		titleTf.width = Math.max(50, toolPanel.x - PADDING);
	}

	override protected function drawBackground(w:Number, h:Number):void {
		var g:Graphics = graphics;
		g.clear();
		if (hostView.showBackground) {
			g.beginFill(AppColors.VIEW_CONTENT_BG, 1);
			g.drawRect(PADDING, 0, w - 2 * PADDING, h);
			g.endFill();
		}

		if (hostView.showHeader) {
			g.beginFill(AppColors.VIEW_HEADER_BG, 1);
			g.drawRect(PADDING, 0, w - 2 * PADDING, hostView.headerHeight);
			g.endFill();
		}

	}

	private function updateTitleText():void {
		if (hostView) titleTf.text = hostView.info.title;
	}
}
}
