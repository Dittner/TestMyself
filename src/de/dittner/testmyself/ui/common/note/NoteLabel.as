package de.dittner.testmyself.ui.common.note {
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.model.domain.note.DeWordArticle;
import de.dittner.testmyself.model.domain.note.IrregularVerb;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.Word;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.AppSizes;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

public class NoteLabel extends UIComponent {
	private const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, _fontSize, _textColor, _isBold);
	private const DIE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, _fontSize, AppColors.TEXT_RED);
	private const DAS_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, _fontSize, AppColors.TEXT_YELLOW);

	public function NoteLabel() {
		super();
	}

	private var titleTF:TextField;

	//--------------------------------------
	//  note
	//--------------------------------------
	private var _note:Note;
	[Bindable("noteChanged")]
	public function get note():Note {return _note;}
	public function set note(value:Note):void {
		if (_note != value) {
			_note = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("noteChanged"));
		}
	}

	//--------------------------------------
	//  mode
	//--------------------------------------
	private var _mode:String = "title";
	[Inspectable(defaultValue="title", enumeration="title,description")]
	[Bindable("modeChanged")]
	public function get mode():String {return _mode;}
	public function set mode(value:String):void {
		if (_mode != value) {
			_mode = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("modeChanged"));
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
			pattern = new RegExp(searchText, "gi");
			invalidateProperties();
			dispatchEvent(new Event("searchTextChanged"));
		}
	}

	//--------------------------------------
	//  fontSize
	//--------------------------------------
	private var formatChanged:Boolean = false;
	private var _fontSize:Number = AppSizes.FONT_SIZE_SMALL;
	[Bindable("fontSizeChanged")]
	public function get fontSize():Number {return _fontSize;}
	public function set fontSize(value:Number):void {
		if (_fontSize != value) {
			_fontSize = value;
			formatChanged = true;
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
			invalidateProperties();
			dispatchEvent(new Event("textAlignChanged"));
		}
	}

	//--------------------------------------
	//  textColor
	//--------------------------------------
	private var _textColor:uint = AppColors.BLACK;
	[Bindable("textColorChanged")]
	public function get textColor():uint {return _textColor;}
	public function set textColor(value:uint):void {
		if (_textColor != value) {
			_textColor = value;
			formatChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("textColorChanged"));
		}
	}

	//--------------------------------------
	//  isBold
	//--------------------------------------
	private var _isBold:Boolean = false;
	[Bindable("isBoldChanged")]
	public function get isBold():Boolean {return _isBold;}
	public function set isBold(value:Boolean):void {
		if (_isBold != value) {
			_isBold = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("isBoldChanged"));
		}
	}

	//--------------------------------------
	//  textThickness
	//--------------------------------------
	private var _textThickness:Number = AppSizes.FONT_DESCRIPTION_THICKNESS;
	[Bindable("textThicknessChanged")]
	public function get textThickness():Number {return _textThickness;}
	public function set textThickness(value:Number):void {
		if (_textThickness != value) {
			_textThickness = value;
			formatChanged = true;
			invalidateProperties();
			dispatchEvent(new Event("textThicknessChanged"));
		}
	}

	//--------------------------------------
	//  horPadding
	//--------------------------------------
	private var _horPadding:Number = 0;
	[Bindable("horPaddingChanged")]
	public function get horPadding():Number {return _horPadding;}
	public function set horPadding(value:Number):void {
		if (_horPadding != value) {
			_horPadding = value;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("horPaddingChanged"));
		}
	}

	//--------------------------------------
	//  verPadding
	//--------------------------------------
	private var _verPadding:Number = 0;
	[Bindable("verPaddingChanged")]
	public function get verPadding():Number {return _verPadding;}
	public function set verPadding(value:Number):void {
		if (_verPadding != value) {
			_verPadding = value;
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("verPaddingChanged"));
		}
	}

	//--------------------------------------
	//  showDetails
	//--------------------------------------
	private var _showDetails:Boolean = true;
	[Bindable("showDetailsChanged")]
	public function get showDetails():Boolean {return _showDetails;}
	public function set showDetails(value:Boolean):void {
		if (_showDetails != value) {
			_showDetails = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchEvent(new Event("showDetailsChanged"));
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
			TITLE_FORMAT.bold = isBold;
			DIE_FORMAT.size = fontSize;
			DIE_FORMAT.bold = isBold;
			DAS_FORMAT.size = fontSize;
			DAS_FORMAT.bold = isBold;
			TITLE_FORMAT.align = textAlign;
			titleTF.thickness = isBold ? 0 : textThickness;
			titleTF.defaultTextFormat = TITLE_FORMAT;
		}

		titleTF.htmlText = getTitleText();
		var article:String = note is Word ? (note as Word).article : "";

		if (article && showDetails && mode == "title") {
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

	private function getTitleText():String {
		if (!note) return "";

		var title:String = "";
		if (mode == "description") {
			title = note.description;
		}
		else {
			if (showDetails) {
				if (note is Word) {
					var word:Word = note as Word;
					title = word.article ? word.article + " " + word.title : word.title;
					if (word.declension) title += ", " + word.declension;
				}
				else if (note is IrregularVerb) {
					var verb:IrregularVerb = note as IrregularVerb;
					title = verb.title + ", " + verb.present + ", " + verb.past + ", " + verb.perfect;
				}
				else {
					title = note.title;
				}

			}
			else {
				title = note is Word || note is IrregularVerb ? "– " + note.title + " –" : note.title;
			}
		}

		return searchText ? title.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>') : title;
	}

	override protected function measure():void {
		super.measure();
		titleTF.width = (width > 0 ? width : Device.width) - 2 * horPadding;
		measuredWidth = titleTF.textWidth + 2 * horPadding;
		measuredHeight = titleTF.textHeight + Values.PT5 + 2 * verPadding;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		titleTF.x = horPadding - Values.PT2;
		titleTF.y = verPadding - Values.PT2;
		titleTF.width = w - 2 * horPadding;
		titleTF.height = titleTF.textHeight + Values.PT5;

		if (titleTF.textHeight > (h - 2 * verPadding)) {
			invalidateSize();
			invalidateDisplayList();
		}
		else if (titleTF.textHeight < (h - 2 * verPadding - Values.PT30)) {
			invalidateSize();
			invalidateDisplayList();
		}
	}

}
}
