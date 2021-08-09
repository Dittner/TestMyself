package {

import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.ui.common.preloader.AppBg;

import flash.display.Graphics;

import spark.components.Group;
import spark.skins.mobile.supportClasses.MobileSkin;

public class TestmyselfAppSkin extends MobileSkin {
	public function TestmyselfAppSkin() {
		super();
	}

	public var contentGroup:Group;
	private var bg:AppBg;

	override protected function createChildren():void {
		bg = new AppBg(Device.width, Device.height);
		addChildAt(bg, 0);

		contentGroup = new Group();
		contentGroup.y = Device.verticalPadding;
		addChild(contentGroup);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0);
		g.drawRect(0, 0, w, h);
		g.endFill();

		contentGroup.y = Device.verticalPadding;
		contentGroup.width = Device.width;
		contentGroup.height = Device.height;

		bg.y = Device.verticalPadding;
		bg.width = Device.width;
		bg.height = Device.isDesktop ? Device.stage.fullScreenHeight : Device.stage.stageHeight;
	}

}
}
