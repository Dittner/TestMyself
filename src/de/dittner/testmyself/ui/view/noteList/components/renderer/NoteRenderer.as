package de.dittner.testmyself.ui.view.noteList.components.renderer {
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
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class NoteRenderer extends ItemRendererBase implements IFlexibleRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT24, AppColors.BLACK);
	private static const EXAMPLES_NUM_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT14, AppColors.BLACK);
	private static const WORD_AND_VERB_TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT26, AppColors.BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT22, AppColors.TEXT_DARK_GRAY);
	private static const DIE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT26, AppColors.TEXT_RED);
	private static const DAS_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT26, AppColors.TEXT_YELLOW);

	protected static const TEXT_DEFAULT_OFFSET:uint = Values.PT1;
	private static const DEF_RENDER_OPTIONS:NoteRenderOptions = new NoteRenderOptions();

	public function NoteRenderer() {
		super();
		percentWidth = 100;
	}

	protected var showSeparatorWhenSelected:Boolean = false;
	protected var titleTf:TextField;
	protected var examplesNumTf:TextField;
	protected var descriptionTf:TextField;
	private var audioIcon:TileShape;
	private var exampleIcon:TileShape;
	private var pattern:RegExp;
	private var searchText:String = "";

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	protected function get gap():uint {return Values.PT10;}

	protected function get verticalPadding():uint {return Values.PT19;}
	protected function get horizontalPadding():uint {return Values.PT19;}

	protected function getTitleTextFormat():TextFormat {
		return word || verb ? WORD_AND_VERB_TITLE_FORMAT : TITLE_FORMAT;
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
		invalidateProperties();
		invalidateSize();
		invalidateDisplayList();
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
			titleTf = TextFieldFactory.createMultiline(TITLE_FORMAT, 80);
			addChild(titleTf);
		}
		if (!examplesNumTf) {
			examplesNumTf = TextFieldFactory.create(EXAMPLES_NUM_FORMAT);
			examplesNumTf.alpha = 0.3;
			addChild(examplesNumTf);
		}
		if (!audioIcon) {
			audioIcon = new TileShape(TileID.BTN_PLAY_AUDIO_UP);
			audioIcon.alpha = 0.3;
			audioIcon.visible = false;
			addChild(audioIcon);
		}

		if (!exampleIcon) {
			exampleIcon = new TileShape(TileID.EXAMPLE_ICON);
			exampleIcon.alpha = 0.3;
			exampleIcon.visible = false;
			addChild(exampleIcon);
		}
	}

	public function invalidateOptions():void {
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
			titleTf.visible = options.showDetails || !options.inverted || selected;
			descriptionTf.visible = options.showDetails || options.inverted || selected;
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
			if (word.declension && (selected || options.showDetails)) title += ", " + word.declension;
		}
		else if (verb) {
			title = verb.title;
			if (selected || options.showDetails) title += ", " + verb.present + ", " + verb.past + ", " + verb.perfect;
		}
		else if (note) {
			title = note.title;
		}

		if (options.searchText != searchText) {
			searchText = options.searchText;
			pattern = new RegExp(searchText, "gi");
		}
		return searchText ? title.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>') : title;
	}

	protected function getDescription():String {
		if (options.searchText != searchText) {
			searchText = options.searchText;
			pattern = new RegExp(searchText, "gi");
		}
		return note ? searchText ? note.description.replace(pattern, '<font color = "#ff5883">' + "$&" + '</font>') : note.description : "";
	}

	override protected function measure():void {
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

		if (w != measuredWidth) {
			invalidateSize();
			invalidateDisplayList();
		}

		exampleIcon.x = w - exampleIcon.measuredWidth - horizontalPadding;
		exampleIcon.y = Values.PT7;
		exampleIcon.visible = note.exampleColl && examplesNumTf.length > 0;
		examplesNumTf.x = exampleIcon.x - examplesNumTf.textWidth - Values.PT4;
		examplesNumTf.y = Values.PT5;

		audioIcon.x = w - audioIcon.measuredWidth - horizontalPadding + Values.PT10;
		audioIcon.y = Values.PT18;
		audioIcon.visible = hasAudioComment();

		g.beginFill(AppColors.REN_SELECTED_BG, selected ? 1 : 0);
		g.drawRect(0, 0, w, h);
		g.endFill();

		if (!selected || showSeparatorWhenSelected) {
			g.beginFill(AppColors.REN_SEP_COLOR);
			g.drawRect(horizontalPadding, showSeparatorWhenSelected ? h - 1 : h, w - 2 * horizontalPadding, 1);
			g.endFill();
		}

		titleTf.x = horizontalPadding - TEXT_DEFAULT_OFFSET;
		descriptionTf.x = horizontalPadding - TEXT_DEFAULT_OFFSET;

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