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

	//--------------------------------------
	//  useDisabledTextAnimation
	//--------------------------------------
	private var _useDisabledTextAnimation:Boolean = false;
	[Bindable("useDisabledTextAnimationChanged")]
	public function get useDisabledTextAnimation():Boolean {return _useDisabledTextAnimation;}
	public function set useDisabledTextAnimation(value:Boolean):void {
		if (_useDisabledTextAnimation != value) {
			_useDisabledTextAnimation = value;
			invalidateDisplayList();
			dispatchEvent(new Event("useDisabledTextAnimationChanged"));
		}
	}

	private var disabledTitleTf:FadeTextField;
	override protected function commitProperties():void {
		super.commitProperties();
		if (title && !disabledTitleTf && useDisabledTextAnimation) {
			disabledTitleTf = TextFieldFactory.createFadeTextField(TITLE_FORMAT, 100);
			addChild(disabledTitleTf);
		}

		if (disabledTitleTf) {
			disabledTitleTf.defaultTextFormat = TITLE_FORMAT;
			disabledTitleTf.textColor = AppColors.DISABLED;
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
		if (disabledTitleTf) {
			disabledTitleTf.animationDuration = animationDuration;
			disabledTitleTf.alphaTo = useDisabledTextAnimation && !enabled ? 1 : 0;
		}
		if (titleTf) {
			titleTf.animationDuration = animationDuration;
			titleTf.alphaTo = upBg.alphaTo;
		}
	}

}
}
