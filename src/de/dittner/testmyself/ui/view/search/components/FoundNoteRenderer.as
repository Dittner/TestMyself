package de.dittner.testmyself.ui.view.search.components {
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.note.verb.DeVerb;
import de.dittner.testmyself.model.domain.note.word.DeWord;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class FoundNoteRenderer extends NoteBaseRenderer implements IFlexibleRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 26, AppColors.TEXT_BLACK, true);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_BLACK);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const PAD:uint = 20;
	private static const GAP:uint = 10;
	private static const SEP_COLOR:uint = 0xc5c5cd;

	[Embed(source='/assets/search/word_icon.png')]
	private static const WordIconClass:Class;
	private static var wordIcon:BitmapData;

	[Embed(source='/assets/search/lesson_icon.png')]
	private static const LessonIconClass:Class;
	private static var lessonIcon:BitmapData;

	[Embed(source='/assets/search/verb_icon.png')]
	private static const VerbIconClass:Class;
	private static var verbIcon:BitmapData;

	[Embed(source='/assets/search/example_icon.png')]
	private static const ExampleIconClass:Class;
	private static var exampleIcon:BitmapData;

	public function FoundNoteRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var titleTf:TextField;
	private var descriptionTf:TextField;
	private var noteBitmap:Bitmap;
	private var noteExampleBitmap:Bitmap;

	public static var _searchingText:String = "";
	public static var pattern:RegExp;
	public static function set searchingText(value:String):void {
		if (_searchingText != value) {
			_searchingText = value;
			pattern = new RegExp(_searchingText, "gi");
		}
	}

	private function get note():INote {
		return data as INote;
	}

	override protected function createChildren():void {
		super.createChildren();
		descriptionTf = createMultilineTextField(DESCRIPTION_FORMAT);
		addChild(descriptionTf);
		titleTf = createMultilineTextField(TITLE_FORMAT);
		addChild(titleTf);
		noteExampleBitmap = new Bitmap(getExampleIcon());
		addChild(noteExampleBitmap);
		noteBitmap = new Bitmap();
		addChild(noteBitmap);
	}

	public function invalidateLayout():void {
		dataChanged = true;
		invalidateProperties();
		invalidateSize();
		invalidateDisplayList();
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			updateData();
		}
	}

	private function updateData():void {
		titleTf.htmlText = getTitle();
		descriptionTf.htmlText = getDescription();
		descriptionTf.visible = selected;
	}

	private function getTitle():String {
		var title:String = "";
		if (note is DeWord) {
			var word:DeWord = note as DeWord;
			if (word.article) title = word.article + " ";
			title += word.title;
			if (word.declension && selected) title += ", " + word.declension;
		}
		else if (note is DeVerb) {
			var verb:DeVerb = note as DeVerb;
			title = verb.title + ", " + verb.present + ", " + verb.past + ", " + verb.perfect;
		}
		else if (note) {
			title = note.title;
		}

		return title;
	}

	private function getDescription():String {
		return note ? note.description : "";
	}

	override protected function measure():void {
		if (!note || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = unscaledWidth;

		if (descriptionTf.visible) {
			titleTf.width = descriptionTf.width = measuredWidth - 2 * PAD;
			measuredHeight = titleTf.textHeight + descriptionTf.textHeight + 2 * PAD + GAP;
		}
		else {
			titleTf.width = measuredWidth - 2 * PAD;
			measuredHeight = titleTf.textHeight + 2 * PAD;
		}
	}

	private var matr:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (!note) return;

		if (w != measuredWidth) {
			invalidateSize();
			invalidateDisplayList();
			return;
		}

		updateSoundIconPos(w, h);

		if (selected) {
			matr.createGradientBox(w, h, Math.PI / 2);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
			g.drawRect(0, 0, w, h);
			g.endFill();

			noteBitmap.bitmapData = getNoteIcon();
			noteBitmap.visible = true;
			noteExampleBitmap.visible = selected && note.isExample;
		}
		else {
			g.lineStyle(1, SEP_COLOR, 0.5);
			g.moveTo(PAD, h - 1);
			g.lineTo(w - 2 * PAD, h - 1);

			noteBitmap.visible = false;
			noteExampleBitmap.visible = false;
		}

		titleTf.textColor = selected ? 0xffFFff : 0;
		titleTf.x = titleTf.y = PAD - TEXT_DEFAULT_OFFSET;

		if (descriptionTf.visible) {
			descriptionTf.textColor = selected ? AppColors.DESCRIPTION_SELECTED_TEXT_COLOR : 0;
			descriptionTf.x = PAD - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = PAD + titleTf.textHeight + GAP - TEXT_DEFAULT_OFFSET;
		}

		if (_searchingText) {
			titleTf.htmlText = getTitle().replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>');
			if (descriptionTf.visible)
				descriptionTf.htmlText = getDescription().replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>');
		}
	}

	private function getNoteIcon():BitmapData {
		if (!note) return null;

		switch (note.vocabulary.id) {
			case VocabularyID.DE_WORD :
				if (!wordIcon) wordIcon = (new WordIconClass() as Bitmap).bitmapData;
				return wordIcon;
			case VocabularyID.DE_VERB :
				if (!verbIcon) verbIcon = (new VerbIconClass() as Bitmap).bitmapData;
				return verbIcon;
			case VocabularyID.DE_LESSON :
				if (!lessonIcon) lessonIcon = (new LessonIconClass() as Bitmap).bitmapData;
				return lessonIcon;
			default :
				return null
		}
	}

	private function getExampleIcon():BitmapData {
		if (!exampleIcon) exampleIcon = (new ExampleIconClass() as Bitmap).bitmapData;
		return exampleIcon;
	}

}
}
