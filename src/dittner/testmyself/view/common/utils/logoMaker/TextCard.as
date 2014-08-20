package dittner.testmyself.view.common.utils.logoMaker {
import dittner.testmyself.view.common.utils.Fonts;
import dittner.testmyself.view.common.utils.TextFieldFactory;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class TextCard extends Sprite {
	private var tf:TextField;
	private var offset:uint;
	private var gradientRotationGrad:int;

	public function TextCard(offset:uint, gradientRotationGrad:int, color:uint, minFontSize:int, maxFontSize:int) {
		super();
		this.offset = offset;
		this.gradientRotationGrad = gradientRotationGrad;
		var fs:int = Math.ceil(Math.random() * (maxFontSize - minFontSize) + minFontSize);
		tf = TextFieldFactory.create(new TextFormat(Fonts.ROBOTO_MX, fs, color));
		addChild(tf);
	}

	//--------------------------------------
	//  text
	//--------------------------------------
	public function get text():String {return tf.text;}
	public function set text(value:String):void {
		if (tf.text != value) {
			tf.text = value;
			draw();
		}
	}

	public function get measuredWidth():Number {return tf.textWidth + 2 * offset}
	public function get measuredHeight():Number {return tf.textHeight + 2 * offset}

	private function draw():void {
		tf.x = offset - 2;
		tf.y = offset - 2;

		var w:Number = measuredWidth;
		var h:Number = measuredHeight;

		var g:Graphics = graphics;
		g.clear();
		var colors:Array = [0, 0x555555];
		var matr:Matrix = new Matrix();
		matr.createGradientBox(w, h, gradientRotationGrad);
		g.beginGradientFill(GradientType.LINEAR, colors, [1, 1], [0, 255], matr);
		g.drawRect(0, 0, w, h);
		g.endFill();
	}
}
}
