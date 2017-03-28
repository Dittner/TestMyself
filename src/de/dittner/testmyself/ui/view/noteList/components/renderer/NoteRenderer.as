package de.dittner.testmyself.ui.view.noteList.components.renderer {
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.note.DeWordArticle;
import de.dittner.testmyself.model.domain.note.IrregularVerb;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.Word;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.view.noteList.components.NoteList;
import de.dittner.testmyself.ui.view.noteList.components.PageLayout;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

public class NoteRenderer extends ItemRendererBase implements IFlexibleRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT24, AppColors.TEXT_BLACK);
	private static const WORD_AND_VERB_TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT26, AppColors.TEXT_BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT22, AppColors.TEXT_DARK_GRAY);
	private static const DIE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT26, AppColors.TEXT_RED);
	private static const DAS_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT26, AppColors.TEXT_YELLOW);
	private static const FOOTER_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT11, AppColors.TEXT_GRAY, null, true, null, null, null, TextAlign.RIGHT);

	protected static const TEXT_DEFAULT_OFFSET:uint = Values.PT1;
	private static const DEF_PAGE_LAYOUT:PageLayout = new PageLayout();

	protected var commentPlayBtn:FadeTileButton;

	public function NoteRenderer() {
		super();
		percentWidth = 100;
	}

	protected var showSeparatorWhenSelected:Boolean = false;
	protected var showWordArticle:Boolean = true;
	protected var titleTf:TextField;
	protected var descriptionTf:TextField;
	private var footerTf:TextField;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	protected function get gap():uint {return Values.PT10;}

	protected function get pad():uint {return Values.PT19;}

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

	private function get pageLayout():PageLayout {
		return parent is NoteList ? (parent as NoteList).pageLayout : DEF_PAGE_LAYOUT;
	}

	protected function hasAudioComment():Boolean {
		if (data is Note && (data as Note).hasAudio) return true;
		else if (data is TestTask && (data as TestTask).note.hasAudio) return true;
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
			titleTf = createMultilineTextField(TITLE_FORMAT, 80);
			addChild(titleTf);
		}
		if (!commentPlayBtn) {
			commentPlayBtn = new FadeTileButton();
			commentPlayBtn.upTileID = TileID.BTN_PLAY_AUDIO_UP;
			commentPlayBtn.downTileID = TileID.BTN_PLAY_AUDIO_DOWN;
			commentPlayBtn.visible = false;
			commentPlayBtn.addEventListener(MouseEvent.CLICK, playComment);
			addChild(commentPlayBtn);
		}

		if (!footerTf) {
			footerTf = createTextField(FOOTER_FORMAT, 50);
			addChild(footerTf);
		}
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

	protected function updateData():void {
		if (note && pageLayout) {
			titleTf.visible = pageLayout.showDetails || !pageLayout.inverted || selected;
			descriptionTf.visible = pageLayout.showDetails || pageLayout.inverted || selected;
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

			if (word && showWordArticle)
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
		}
	}

	protected function getTitle():String {
		var title:String = "";
		if (word) {
			if (word.article && showWordArticle)
				title = word.article + " ";
			title += word.title;
			if (word.declension && (selected || pageLayout.showDetails)) title += ", " + word.declension;
		}
		else if (verb) {
			title = verb.title;
			if (selected || pageLayout.showDetails) title += ", " + verb.present + ", " + verb.past + ", " + verb.perfect;
		}
		else if (note) {
			title = note.title;
		}

		return title;
	}

	protected function getDescription():String {
		return note ? note.description : "";
	}

	override protected function measure():void {
		if (!note || !pageLayout || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = parent.width;

		if (titleTf.visible && descriptionTf.visible) {
			titleTf.width = descriptionTf.width = measuredWidth - pad - commentPlayBtn.width;
			measuredHeight = Math.ceil(titleTf.textHeight + descriptionTf.textHeight + 2 * pad + gap + footerTf.textHeight);
		}
		else if (descriptionTf.visible) {
			descriptionTf.width = measuredWidth - pad - commentPlayBtn.width;
			measuredHeight = Math.ceil(descriptionTf.textHeight + 2 * pad);
		}
		else {
			titleTf.width = measuredWidth - pad - commentPlayBtn.width;
			measuredHeight = Math.ceil(titleTf.textHeight + 2 * pad);
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

		commentPlayBtn.x = w - commentPlayBtn.width;
		commentPlayBtn.y = 72*Device.factor - commentPlayBtn.height >> 1;
		commentPlayBtn.visible = hasAudioComment();
		commentPlayBtn.enabled = selected;

		g.beginFill(AppColors.REN_SELECTED_BG, selected ? 1 : 0);
		g.drawRect(0, 0, w, h);
		g.endFill();

		if (!selected || showSeparatorWhenSelected) {
			g.beginFill(AppColors.REN_SEP_COLOR);
			g.drawRect(pad, showSeparatorWhenSelected ? h - 1 : h, w - 2 * pad, 1);
			g.endFill();
		}

		titleTf.x = pad - TEXT_DEFAULT_OFFSET;
		descriptionTf.x = pad - TEXT_DEFAULT_OFFSET;

		if (titleTf.visible && descriptionTf.visible) {
			titleTf.y = pad - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = pad + titleTf.textHeight + gap - TEXT_DEFAULT_OFFSET;
		}
		else if (descriptionTf.visible) {
			descriptionTf.y = pad - TEXT_DEFAULT_OFFSET;
		}
		else if (titleTf.visible) {
			titleTf.y = pad - TEXT_DEFAULT_OFFSET;
		}

		if (selected) {
			footerTf.visible = true;
			footerTf.text = getFooterText();
			footerTf.x = pad;
			footerTf.y = h - footerTf.textHeight - Values.PT5;
			footerTf.width = w - footerTf.x - pad;
		}
		else {
			footerTf.visible = false;
		}
	}

	private function getFooterText():String {
		var res:String = "";
		if (note) {
			res = getVocabularySymbol();
			if (note.isExample) res += "  " + getExampleSymbol();
			else if (note.tagIDs && note.tagIDs.length > 0)
				res += "  " + note.tagsToStr();
		}
		return res;
	}

	private function getVocabularySymbol():String {
		if (!note) return "";

		switch (note.vocabulary.id) {
			case VocabularyID.DE_WORD :
			case VocabularyID.EN_WORD :
				return "–W–";
			case VocabularyID.DE_VERB :
			case VocabularyID.EN_VERB :
				return "–V–";
			case VocabularyID.DE_LESSON :
				return "–Ü–";
			case VocabularyID.EN_LESSON :
				return "–L–";
			default :
				return ""
		}
	}

	private function getExampleSymbol():String {
		if (note && note.vocabulary.lang.id == LanguageID.DE) {
			return "Bsp.";
		}
		else if (note && note.vocabulary.lang.id == LanguageID.EN) {
			return "e. g.";
		}
		return "";
	}

	private function playComment(e:Event):void {
		if (!selected) return;
		e.stopImmediatePropagation();
		if (note && note.hasAudio)
			note.loadAndPlayAudioComment();
	}

}
}
