package de.dittner.testmyself.ui.common.note {
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.model.domain.note.DeWordArticle;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

public class NoteLabel extends UIComponent {
	private const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, _fontSize, _textColor);
	private const DIE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, _fontSize, AppColors.TEXT_RED);
	private const DAS_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, _fontSize, AppColors.TEXT_YELLOW);

	public function NoteLabel() {
		super();
	}
	private var titleTF:TextField;

	//--------------------------------------
	//  text
	//--------------------------------------
	private var textChanged:Boolean = false;
	private var _text:String = "";
	[Bindable("textChanged")]
	public function get text():String {return _text;}
	public function set text(value:String):void {
		if (_text != value) {
			_text = value;
			textChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("textChanged"));
		}
	}

	//--------------------------------------
	//  article
	//--------------------------------------
	private var _article:String = "";
	[Bindable("articleChanged")]
	public function get article():String {return _article;}
	public function set article(value:String):void {
		if (_article != value) {
			_article = value;
			textChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("articleChanged"));
		}
	}

	//--------------------------------------
	//  searchText
	//--------------------------------------
	private var pattern:RegExp;
	private var _searchText:String = "";
	[Bindable("searchTextChanged")]
	public function get searchText():String {return _searchText;}
	public function set searchText(value:String):void {
		if (_searchText != value) {
			_searchText = value;
			textChanged = true;
			pattern = new RegExp(searchText, "gi");
			invalidateProperties();
			dispatchEvent(new Event("searchTextChanged"));
		}
	}

	//--------------------------------------
	//  fontSize
	//--------------------------------------
	private var formatChanged:Boolean = false;
	private var _fontSize:Number = Values.PT24;
	[Bindable("fontSizeChanged")]
	public function get fontSize():Number {return _fontSize;}
	public function set fontSize(value:Number):void {
		if (_fontSize != value) {
			_fontSize = value;
			formatChanged = true;
			textChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("fontSizeChanged"));
		}
	}

	//--------------------------------------
	//  textAlign
	//--------------------------------------
	private var _textAlign:String = "left";
	[Bindable("textAlignChanged")]
	public function get textAlign():String {return _textAlign;}
	public function set textAlign(value:String):void {
		if (_textAlign != value) {
			_textAlign = value;
			formatChanged = true;
			textChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("textAlignChanged"));
		}
	}

	//--------------------------------------
	//  textColor
	//--------------------------------------
	private var _textColor:uint = AppColors.TEXT_BLACK;
	[Bindable("textColorChanged")]
	public function get textColor():uint {return _textColor;}
	public function set textColor(value:uint):void {
		if (_textColor != value) {
			_textColor = value;
			formatChanged = true;
			textChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("textColorChanged"));
		}
	}

	//--------------------------------------
	//  textThickness
	//--------------------------------------
	private var _textThickness:Number = 20;
	[Bindable("textThicknessChanged")]
	public function get textThickness():Number {return _textThickness;}
	public function set textThickness(value:Number):void {
		if (_textThickness != value) {
			_textThickness = value;
			formatChanged = true;
			textChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("textThicknessChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();
		if (!titleTF) {
			titleTF = TextFieldFactory.createMultiline(TITLE_FORMAT, textThickness);
			titleTF.selectable = Device.isDesktop;
			titleTF.mouseEnabled = Device.isDesktop;
			addChild(titleTF);
		}
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (formatChanged) {
			formatChanged = false;
			TITLE_FORMAT.color = textColor;
			TITLE_FORMAT.size = fontSize;
			DIE_FORMAT.size = fontSize;
			DAS_FORMAT.size = fontSize;
			TITLE_FORMAT.align = textAlign;
			titleTF.thickness = textThickness;
			titleTF.defaultTextFormat = TITLE_FORMAT;
		}

		if (textChanged) {
			textChanged = false;

			titleTF.htmlText = getTitleText();

			if (article) {
				switch (article) {
					case DeWordArticle.DIE :
						titleTF.setTextFormat(DIE_FORMAT, 0, article.length);
						break;
					case DeWordArticle.DAS :
						titleTF.setTextFormat(DAS_FORMAT, 0, article.length);
						break;
					case DeWordArticle.DER_DIE :
						titleTF.setTextFormat(DIE_FORMAT, 4, article.length);
						break;
					case DeWordArticle.DER_DAS :
						titleTF.setTextFormat(DAS_FORMAT, 4, article.length);
						break;
					case DeWordArticle.DIE_DAS :
						titleTF.setTextFormat(DIE_FORMAT, 0, 4);
						titleTF.setTextFormat(DAS_FORMAT, 4, article.length);
						break;
					case DeWordArticle.DER_DIE_DAS :
						titleTF.setTextFormat(DIE_FORMAT, 4, article.length);
						titleTF.setTextFormat(DAS_FORMAT, 8, article.length);
						break;
				}
			}
		}
	}

	private function getTitleText():String {
		var title:String = "";
		if (article) title = article + " ";
		title += text;
		return searchText ? title.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>') : title;
	}

	override protected function measure():void {
		super.measure();
		measuredWidth = titleTF.textWidth + Values.PT5;
		measuredMinHeight = measuredHeight = titleTF.textHeight + Values.PT5;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		titleTF.x = -Values.PT2;
		titleTF.y = -Values.PT2;
		titleTF.width = w;
		titleTF.height = h;
	}
}
}
