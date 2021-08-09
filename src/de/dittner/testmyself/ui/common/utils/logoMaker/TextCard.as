package de.dittner.testmyself.ui.common.utils.logoMaker {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

public class TextCard extends UIComponent {
	private var tf:TextField;
	private var offset:uint;
	private var color:uint;
	private var gradientRotationGrad:int;
	private var fs:int;

	public function TextCard(offset:uint, gradientRotationGrad:int, color:uint, minFontSize:int, maxFontSize:int) {
		super();
		this.offset = offset;
		this.color = color;
		this.gradientRotationGrad = gradientRotationGrad;
		fs = Math.ceil(Math.random() * (maxFontSize - minFontSize) + minFontSize);
	}

	//--------------------------------------
	//  text
	//--------------------------------------
	private var _text:String = "";
	public function get text():String {return _text;}
	public function set text(value:String):void {
		if (_text != value) {
			_text = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
	}

	override protected function createChildren():void {
		super.createChildren();
		tf = TextFieldFactory.create(new TextFormat(FontName.BASIC_MX, fs, color));
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		tf.text = text;
	}

	override protected function measure():void {
		measuredWidth = tf.textWidth + 2 * offset;
		measuredHeight = tf.textHeight + 2 * offset;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		tf.x = (w - tf.textWidth >> 1) - 2;
		tf.y = (h - tf.textHeight >> 1) - 2;

		var g:Graphics = graphics;
		g.clear();
		var matr:Matrix = new Matrix();
		matr.createGradientBox(w, h, gradientRotationGrad / 180 * Math.PI);
		g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
		g.drawRect(0, 0, w, h);
		g.endFill();
	}
}
}
