package dittner.testmyself.deutsch.view.common.utils.logoMaker {
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.TextFieldFactory;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

public class LabelCard extends UIComponent {
	private var cardWidth:uint;
	private var cardHeight:uint;
	private var color:uint;
	private var fontSize:uint;
	private var gap:uint;
	private var gradientRotationGrad:int;
	private var text:String;
	private var fontName:String;
	private var letters:Array = [];

	public function LabelCard(text:String, cardWidth:uint, cardHeight:uint, gap:uint, gradientRotationGrad:int, color:uint, fontSize:int, fontName:String) {
		super();
		this.text = text;
		this.fontName = fontName;
		this.cardWidth = cardWidth;
		this.cardHeight = cardHeight;
		this.color = color;
		this.fontSize = fontSize;
		this.gap = gap;
		this.gradientRotationGrad = gradientRotationGrad;
	}

	override protected function createChildren():void {
		super.createChildren();
		var tf:TextField;
		for (var i:int = 0; i < text.length; i++) {
			tf = TextFieldFactory.create(new TextFormat(fontName, fontSize, color));
			tf.text = text.charAt(i);
			letters.push(tf);
			addChild(tf);
		}
	}

	override protected function measure():void {
		measuredWidth = (cardWidth + gap) * letters.length;
		measuredHeight = cardHeight;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		var tf:TextField;
		var matr:Matrix = new Matrix();
		matr.createGradientBox(cardWidth, cardHeight, gradientRotationGrad / 180 * Math.PI);
		g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);

		for (var i:int = 0; i < letters.length; i++) {
			tf = letters[i];
			tf.x = (cardWidth + gap) * i + (cardWidth - tf.textWidth >> 1) - 2;
			tf.y = (cardHeight - tf.textHeight >> 1) - 2;
			tf.width = tf.textWidth + 5;
			tf.height = tf.textHeight + 5;
			if (tf.text == " ") continue;
			g.drawRect((cardWidth + gap) * i, 0, cardWidth, cardHeight);
		}
		g.endFill();
	}
}
}
