package de.dittner.testmyself.ui.common.panel {
import spark.components.Group;
import spark.skins.mobile.supportClasses.MobileSkin;

public class CollapsedPanelSkin extends MobileSkin {
	public function CollapsedPanelSkin() {
		super();
	}

	public var headerBtn:CollapsedTileButton;
	public var contentGroup:Group;
	public var hostComponent:CollapsedPanel;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	override protected function commitCurrentState():void {
		super.commitCurrentState();
		alpha = currentState.indexOf("disabled") == -1 ? 1 : 0.5;
	}

	override protected function createChildren():void {
		contentGroup = new Group();
		contentGroup.id = "contentGroup";
		contentGroup.left = contentGroup.right = contentGroup.top = contentGroup.bottom = 0;
		contentGroup.minWidth = contentGroup.minHeight = 0;
		addChild(contentGroup);

		headerBtn = new CollapsedTileButton();
		headerBtn.id = "headerBtn";
		addChild(headerBtn);
	}

	override protected function measure():void {
		super.measure();
		measuredWidth = contentGroup.getPreferredBoundsWidth() + hostComponent.paddingLeft + hostComponent.paddingRight;
		if (hostComponent.isOpened) {
			measuredHeight = contentGroup.getPreferredBoundsHeight() + headerBtn.getExplicitOrMeasuredHeight() + hostComponent.paddingTop + hostComponent.paddingBottom;
		}
		else {
			measuredHeight = headerBtn.getExplicitOrMeasuredHeight();
		}
	}

	override protected function layoutContents(w:Number, h:Number):void {
		super.layoutContents(w, h);
		headerBtn.width = w;
		contentGroup.setLayoutBoundsSize(w - hostComponent.paddingLeft - hostComponent.paddingRight, h - headerBtn.getExplicitOrMeasuredHeight() - hostComponent.paddingTop - hostComponent.paddingBottom);
		contentGroup.setLayoutBoundsPosition(hostComponent.paddingLeft, headerBtn.getExplicitOrMeasuredHeight() + hostComponent.paddingTop);
		contentGroup.visible = headerBtn.selected;
	}

	override protected function drawBackground(w:Number, h:Number):void {
		graphics.beginFill(getStyle("backgroundColor"), getStyle("backgroundAlpha"));
		graphics.drawRect(0, headerBtn.getExplicitOrMeasuredHeight(), w, h - headerBtn.getExplicitOrMeasuredHeight());
		graphics.endFill();
	}
}
}