package de.dittner.testmyself.ui.view.noteList.components {
import de.dittner.testmyself.model.domain.note.DeWordArticle;
import de.dittner.testmyself.model.domain.note.IrregularVerb;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.Word;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.ui.common.note.NoteList;
import de.dittner.testmyself.ui.common.note.NoteRenderOptions;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.tile.TileID;
import de.dittner.testmyself.ui.common.tile.TileShape;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.AppSizes;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class NoteRenderer extends ItemRendererBase implements INoteRenderer {
	private static const LESSONS_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_MIDDLE, AppColors.BLACK, false);
	private static const EXAMPLES_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_MIDDLE, AppColors.BLACK, true);
	private static const WORD_AND_VERB_TITLE_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_LARGE, AppColors.BLACK, true);
	private static const EXAMPLES_NUM_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, Values.PT14, AppColors.BLACK, false);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_SMALL, AppColors.TEXT_DARK_GRAY, false);
	private static const DIE_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_LARGE, AppColors.TEXT_RED, true);
	private static const DAS_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_LARGE, AppColors.TEXT_YELLOW, true);

	protected static const TEXT_DEFAULT_OFFSET:uint = Values.PT1;
	private static const DEF_RENDER_OPTIONS:NoteRenderOptions = new NoteRenderOptions();

	public function NoteRenderer() {
		super();
		percentWidth = 100;
	}

	protected var titleTf:TextField;
	protected var examplesNumTf:TextField;
	protected var descriptionTf:TextField;
	private var audioIcon:TileShape;
	private var exampleIcon:TileShape;
	private var favoriteIcon:TileShape;
	private var pattern:RegExp;
	private var searchText:String = "";
	protected var cardViewMode:Boolean = false;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	protected function get gap():uint {return Values.PT5;}

	protected function get verticalPadding():uint {return Values.PT19;}
	protected function get horizontalPadding():uint {return Values.PT15;}

	protected function getTitleTextFormat():TextFormat {
		return word || verb ? WORD_AND_VERB_TITLE_FORMAT : example ? EXAMPLES_FORMAT : LESSONS_FORMAT;
	}

	protected function get testTask():TestTask {
		return data as TestTask;
	}

	protected function get note():Note {
		return testTask ? testTask.note : data as Note;
	}

	protected function get word():Word {
		return testTask && testTask.note is Word ? testTask.note as Word : data as Word;
	}

	protected function get verb():IrregularVerb {
		return testTask && testTask.note is IrregularVerb ? testTask.note as IrregularVerb : data as IrregularVerb;
	}

	protected function get example():Note {
		return note && note.isExample ? note : null;
	}

	private function get options():NoteRenderOptions {
		return parent is NoteList ? (parent as NoteList).renderOptions : DEF_RENDER_OPTIONS;
	}

	protected function hasAudioComment():Boolean {
		if (data is Note && (data as Note).hasAudio) return true;
		else if (data is TestTask && (data as TestTask).note && (data as TestTask).note.hasAudio) return true;
		else return false;
	}

	override public function set selected(value:Boolean):void {
		super.selected = value;
		dataChanged = true;
		if (cardViewMode) {
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();
		if (!descriptionTf) {
			descriptionTf = createMultilineTextField(DESCRIPTION_FORMAT);
			addChild(descriptionTf);
		}
		if (!titleTf) {
			titleTf = TextFieldFactory.createMultiline(LESSONS_FORMAT);
			addChild(titleTf);
		}
		if (!examplesNumTf) {
			examplesNumTf = TextFieldFactory.create(EXAMPLES_NUM_FORMAT);
			examplesNumTf.alpha = 0.4;
			addChild(examplesNumTf);
		}
		if (!audioIcon) {
			audioIcon = new TileShape(TileID.PLAY_AUDIO_ICON);
			audioIcon.alpha = 0.4;
			audioIcon.visible = false;
			addChild(audioIcon);
		}

		if (!exampleIcon) {
			exampleIcon = new TileShape(TileID.EXAMPLE_ICON);
			exampleIcon.alpha = 0.4;
			exampleIcon.visible = false;
			addChild(exampleIcon);
		}

		if (!favoriteIcon) {
			favoriteIcon = new TileShape(TileID.FAVORITE_ICON);
			favoriteIcon.alpha = 0.4;
			favoriteIcon.visible = false;
			addChild(favoriteIcon);
		}
	}

	public function invalidatePropertiesSizeAndDisplayList():void {
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

	protected function updateData():void {
		if (note && options) {
			if (options.searchText != searchText) {
				searchText = options.searchText;
				pattern = new RegExp(searchText, "gi");
			}
			titleTf.visible = options.showDetails || !options.inverted || (selected && cardViewMode);
			descriptionTf.visible = options.showDetails || options.inverted || (selected && cardViewMode);
			updateText();
		}
		else {
			titleTf.visible = true;
			descriptionTf.visible = false;
		}
	}

	protected function updateText():void {
		if (note) {
			titleTf.defaultTextFormat = getTitleTextFormat();
			titleTf.htmlText = getTitle();
			descriptionTf.htmlText = getDescription();
			examplesNumTf.text = note.exampleColl && note.exampleColl.length > 0 ? note.exampleColl.length.toString() : "";

			if (word && options.showWordArticle)
				switch (word.article) {
					case DeWordArticle.DIE :
						titleTf.setTextFormat(DIE_FORMAT, 0, word.article.length);
						break;
					case DeWordArticle.DAS :
						titleTf.setTextFormat(DAS_FORMAT, 0, word.article.length);
						break;
					case DeWordArticle.DER_DIE :
						titleTf.setTextFormat(DIE_FORMAT, 4, word.article.length);
						break;
					case DeWordArticle.DER_DAS :
						titleTf.setTextFormat(DAS_FORMAT, 4, word.article.length);
						break;
					case DeWordArticle.DIE_DAS :
						titleTf.setTextFormat(DIE_FORMAT, 0, 4);
						titleTf.setTextFormat(DAS_FORMAT, 4, word.article.length);
						break;
					case DeWordArticle.DER_DIE_DAS :
						titleTf.setTextFormat(DIE_FORMAT, 4, word.article.length);
						titleTf.setTextFormat(DAS_FORMAT, 8, word.article.length);
						break;
				}
		}
		else {
			titleTf.htmlText = "";
			descriptionTf.htmlText = "";
			examplesNumTf.text = "";
		}
	}

	protected function getTitle():String {
		var title:String = "";
		if (word) {
			if (word.article && options.showWordArticle)
				title = word.article + " ";
			title += word.title;
			if (word.declension && ((selected && cardViewMode) || options.showDetails)) title += ", " + word.declension;
		}
		else if (verb) {
			title = verb.title;
			if ((selected && cardViewMode) || options.showDetails) {
				title += verb.present ? ", " + verb.present : "";
				title += verb.past ? ", " + verb.past : "";
				title += verb.perfect ? ", " + verb.perfect : "";
			}
		}
		else if (note) {
			title = note.title;
		}

		return searchText ? title.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>') : title;
	}

	protected function getDescription():String {
		if (!note) return "";

		if (options.searchText != searchText) {
			searchText = options.searchText;
			pattern = new RegExp(searchText, "gi");
		}

		if (searchText) {
			if (note.description.length > 300 && !(note is Word || note is IrregularVerb)) {
				var txt:String = note.description;
				txt = txt.replace(/(<b>)/gi, "");
				txt = txt.replace(/(<\/b>)/gi, "");
				txt = txt.replace(/(<i>)/gi, "");
				txt = txt.replace(/(<\/i>)/gi, "");

				var sentences:Array = txt.split(/\.|!|\?|\n/gi);
				var res:String = "";
				for each(var s:String in sentences)
					if (s.length >= searchText.length && s.toLowerCase().indexOf(searchText) != -1)
						res += "&lt;...&gt; " + (s.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>') + "...\n");
				return res.replace(/( {2,})/gi, " ");
			}
			else {
				return note.description.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>');
			}
		}
		else {
			return note.description;
		}
	}

	override protected function measure():void {
		super.measure();
		if (!note || !options || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = parent.width;

		if (titleTf.visible && descriptionTf.visible) {
			titleTf.width = measuredWidth - 2 * horizontalPadding - audioIcon.width / 2;
			descriptionTf.width = measuredWidth - 2 * horizontalPadding;
			measuredHeight = Math.ceil(titleTf.textHeight + descriptionTf.textHeight + 2 * verticalPadding + gap);
		}
		else if (descriptionTf.visible) {
			descriptionTf.width = measuredWidth - 2 * horizontalPadding - audioIcon.width / 2;
			measuredHeight = Math.ceil(descriptionTf.textHeight + 2 * verticalPadding);
		}
		else {
			titleTf.width = measuredWidth - 2 * horizontalPadding - audioIcon.width / 2;
			measuredHeight = Math.ceil(titleTf.textHeight + 2 * verticalPadding);
		}
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		exampleIcon.x = w - exampleIcon.measuredWidth - horizontalPadding + Values.PT1;
		exampleIcon.y = Values.PT6;
		exampleIcon.visible = note && note.exampleColl && examplesNumTf.length > 0;
		examplesNumTf.x = exampleIcon.x - examplesNumTf.textWidth - Values.PT3;
		examplesNumTf.y = Values.PT2;

		audioIcon.x = w - audioIcon.measuredWidth - horizontalPadding + Values.PT3;
		audioIcon.y = Values.PT25;
		audioIcon.visible = hasAudioComment();

		favoriteIcon.x = w - favoriteIcon.measuredWidth - horizontalPadding + Values.PT3;
		favoriteIcon.y = Values.PT45;
		favoriteIcon.visible = note && note.isFavorite();

		g.beginFill(0, 0);
		g.drawRect(0, 0, w, h);
		g.endFill();

		g.beginFill(0, 0.5);
		g.drawRect(horizontalPadding, h - 1, w - 2 * horizontalPadding, 1);
		g.endFill();

		titleTf.x = horizontalPadding - TEXT_DEFAULT_OFFSET;
		descriptionTf.x = horizontalPadding - TEXT_DEFAULT_OFFSET;
		titleTf.width = w - 2 * horizontalPadding - audioIcon.width / 2;
		descriptionTf.width = w - 2 * horizontalPadding;

		if (titleTf.visible && descriptionTf.visible) {
			titleTf.y = verticalPadding - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = verticalPadding + titleTf.textHeight + gap - TEXT_DEFAULT_OFFSET;
		}
		else if (descriptionTf.visible) {
			descriptionTf.y = verticalPadding - TEXT_DEFAULT_OFFSET;
		}
		else if (titleTf.visible) {
			titleTf.y = verticalPadding - TEXT_DEFAULT_OFFSET;
		}
	}
}
}