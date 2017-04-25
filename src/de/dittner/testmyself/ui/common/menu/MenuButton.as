package de.dittner.testmyself.ui.common.menu {
import de.dittner.testmyself.ui.common.tile.FadeTextField;
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;

import flash.events.Event;

public class MenuButton extends FadeTileButton {
	public function MenuButton() {
		super();
		upBgAlpha = 0.6;
		disabledBgAlpha = 0.6;
		animationDuration = 0.6;
		textColor = 0;
	}

	//--------------------------------------
	//  menuID
	//--------------------------------------
	private var _menuID:String = "";
	[Bindable("menuIDChanged")]
	public function get menuID():String {return _menuID;}
	public function set menuID(value:String):void {
		if (_menuID != value) {
			_menuID = value;
			dispatchEvent(new Event("menuIDChanged"));
		}
	}

	override public function set enabled(value:Boolean):void {
		if (super.enabled != value) {
			super.enabled = value;
			if (titleTf && disabledTitleTf) {
				titleTf.alphaTo = enabled ? 1 : 0;
				disabledTitleTf.alphaTo = enabled ? 0 : 1;
			}
		}
	}

	private var disabledTitleTf:FadeTextField;
	override protected function commitProperties():void {
		super.commitProperties();
		if (title && !disabledTitleTf) {
			disabledTitleTf = TextFieldFactory.createFadeTextField(TITLE_FORMAT);
			disabledTitleTf.alpha = enabled ? 0 : 1;
			addChild(disabledTitleTf);
		}

		if (disabledTitleTf) {
			disabledTitleTf.defaultTextFormat = TITLE_FORMAT;
			disabledTitleTf.textColor = AppColors.MENU_BTN_DISABLED;
			disabledTitleTf.text = title;
		}
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		if (titleTf && disabledTitleTf) {
			disabledTitleTf.x = titleTf.x;
			disabledTitleTf.y = titleTf.y;
			disabledTitleTf.width = titleTf.width;
			disabledTitleTf.height = titleTf.height;
		}
	}

	override protected function redrawBg():void {
		super.redrawBg();
		if (titleTf && disabledTitleTf) {
			titleTf.animationDuration = disabledTitleTf.animationDuration = animationDuration;
			titleTf.alphaTo = enabled ? upBg.alphaTo : 0;
		}
	}

}
}
