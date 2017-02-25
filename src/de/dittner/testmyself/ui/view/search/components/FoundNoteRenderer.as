package de.dittner.testmyself.ui.view.search.components {
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.view.noteList.components.renderer.NoteRenderer;

import flash.display.Bitmap;
import flash.display.BitmapData;

public class FoundNoteRenderer extends NoteRenderer {

	[Embed(source='/assets/search/word_icon.png')]
	private static const WordIconClass:Class;
	private static var wordIcon:BitmapData;

	[Embed(source='/assets/search/de_lesson_icon.png')]
	private static const DeLessonIconClass:Class;
	private static var deLessonIcon:BitmapData;

	[Embed(source='/assets/search/en_lesson_icon.png')]
	private static const EnLessonIconClass:Class;
	private static var enLessonIcon:BitmapData;

	[Embed(source='/assets/search/verb_icon.png')]
	private static const VerbIconClass:Class;
	private static var verbIcon:BitmapData;

	[Embed(source='/assets/search/de_example_icon.png')]
	private static const DeExampleIconClass:Class;
	private static var deExampleIcon:BitmapData;

	[Embed(source='/assets/search/en_example_icon.png')]
	private static const EnExampleIconClass:Class;
	private static var enExampleIcon:BitmapData;

	public function FoundNoteRenderer() {
		super();
	}

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

	override protected function createChildren():void {
		super.createChildren();
		noteExampleBitmap = new Bitmap();
		addChild(noteExampleBitmap);
		noteBitmap = new Bitmap();
		addChild(noteBitmap);
	}

	override protected function getTitle():String {
		var res:String = super.getTitle();
		return res.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>');
	}

	override protected function getDescription():String {
		var res:String = super.getDescription();
		return res.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>');
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		if (!data) return;

		if (w != measuredWidth) {
			invalidateSize();
			invalidateDisplayList();
			return;
		}

		if (selected) {
			noteBitmap.bitmapData = getNoteIcon();
			noteBitmap.visible = true;
			noteExampleBitmap.visible = selected && note.isExample;
			if (noteExampleBitmap.visible)
				noteExampleBitmap.bitmapData = getExampleIcon();
		}
		else {
			noteBitmap.visible = false;
			noteExampleBitmap.visible = false;
		}
	}

	private function getNoteIcon():BitmapData {
		if (!note) return null;

		switch (note.vocabulary.id) {
			case VocabularyID.DE_WORD :
			case VocabularyID.EN_WORD :
				if (!wordIcon) wordIcon = (new WordIconClass() as Bitmap).bitmapData;
				return wordIcon;
			case VocabularyID.DE_VERB :
			case VocabularyID.EN_VERB :
				if (!verbIcon) verbIcon = (new VerbIconClass() as Bitmap).bitmapData;
				return verbIcon;
			case VocabularyID.DE_LESSON :
				if (!deLessonIcon) deLessonIcon = (new DeLessonIconClass() as Bitmap).bitmapData;
				return deLessonIcon;
			case VocabularyID.EN_LESSON :
				if (!enLessonIcon) enLessonIcon = (new EnLessonIconClass() as Bitmap).bitmapData;
				return enLessonIcon;
			default :
				return null
		}
	}

	private function getExampleIcon():BitmapData {
		var res:BitmapData;
		if (note && note.vocabulary.lang.id == LanguageID.DE) {
			if (!deExampleIcon) deExampleIcon = (new DeExampleIconClass() as Bitmap).bitmapData;
			res = deExampleIcon;
		}
		else if (note && note.vocabulary.lang.id == LanguageID.EN) {
			if (!enExampleIcon) enExampleIcon = (new EnExampleIconClass() as Bitmap).bitmapData;
			res = enExampleIcon;
		}
		return res;
	}

}
}
