package dittner.testmyself.deutsch.view.note.form.word {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.model.domain.word.Word;
import dittner.testmyself.deutsch.view.note.form.*;

import mx.collections.ArrayCollection;

public class WordFormState extends NoteFormState {
	public function WordFormState(form:NoteForm) {
		this.form = form;
	}

	private var form:NoteForm;

	override public function edit(note:INote):void {
		var word:Word = note as Word;
		if (form.articleBox) form.articleBox.selectedItem = word.article;
		if (form.wordInput) form.wordInput.text = word.title;
		if (form.wordOptionsInput) form.wordOptionsInput.text = word.options;
		if (form.descriptionArea) form.descriptionArea.text = word.description;
		if (form.audioRecorder) form.audioRecorder.comment = word.audioComment;
	}

	override public function remove(note:INote):void {
		form.removeNoteTitleLbl.text = '«' + note.title + '»';
	}

	override public function clear():void {
		if (form.articleBox) form.articleBox.selectedItem = "";
		if (form.wordInput) form.wordInput.text = "";
		if (form.wordOptionsInput) form.wordOptionsInput.text = "";
		if (form.descriptionArea) form.descriptionArea.text = "";
		if (form.addThemeInput) form.addThemeInput.text = "";
		if (form.audioRecorder) form.audioRecorder.clear();
		if (form.examplesForm) form.examplesForm.clear();
		form.themes = new ArrayCollection();
	}

	override public function updateLayout(w:Number, h:Number):void {
		with (form) {
			showControls();
			var firstColumnWid:Number = w - 2 * PAD - HGAP - THEMES_LIST_WID;
			var formContentHeight:Number = (h - FOOTER_HEI - HEADER_HEI - PAD - PAD_TOP - RECORDER_HEI);
			articleBox.x = PAD;
			articleBox.y = HEADER_HEI + PAD_TOP;

			wordInput.x = articleBox.x + articleBox.width + HGAP;
			wordInput.y = HEADER_HEI + PAD_TOP;
			wordInput.width = (firstColumnWid - articleBox.width - 2 * HGAP) / 2;

			wordOptionsInput.x = wordInput.x + wordInput.width + HGAP;
			wordOptionsInput.y = wordInput.y;
			wordOptionsInput.width = wordInput.width;

			descriptionArea.x = wordInput.x;
			descriptionArea.y = wordOptionsInput.y + wordOptionsInput.height + VGAP;
			descriptionArea.height = 4 * wordInput.height;
			descriptionArea.width = firstColumnWid - wordInput.x + 2 * HGAP;

			examplesForm.x = PAD;
			examplesForm.y = descriptionArea.y + descriptionArea.height + VGAP;
			examplesForm.toolsCont.width = articleBox.width;
			examplesForm.horizontalLayout.gap = HGAP;
			examplesForm.width = firstColumnWid;
			examplesForm.height = formContentHeight - examplesForm.y + HEADER_HEI + PAD_TOP;

			themesList.x = descriptionArea.x + descriptionArea.width + HGAP;
			themesList.y = HEADER_HEI + PAD_TOP;
			themesList.height = formContentHeight;
			themesList.width = THEMES_LIST_WID;

			audioRecorder.x = wordInput.x;
			audioRecorder.y = themesList.y + themesList.height + VGAP;
			audioRecorder.width = firstColumnWid - wordInput.x + PAD;
			audioRecorder.height = RECORDER_HEI;

			addThemeInput.x = themesList.x;
			addThemeInput.y = themesList.y + themesList.height + VGAP;
			addThemeInput.width = themesList.width - addThemeBtn.width + 1;

			addThemeBtn.x = addThemeInput.x + addThemeInput.width - 1;
			addThemeBtn.y = addThemeInput.y + 20;

			applyBtn.width = THEMES_LIST_WID;
			applyBtn.right = PAD;
			applyBtn.bottom = (FOOTER_HEI - applyBtn.height + BORDER_THICKNESS) / 2;

			cancelBtn.right = applyBtn.width + applyBtn.right + HGAP;
			cancelBtn.bottom = applyBtn.bottom;
			cancelBtn.width = applyBtn.width;
			cancelBtn.height = applyBtn.height;

			invalidNotifier.left = PAD;
			invalidNotifier.right = cancelBtn.width + cancelBtn.right + HGAP;
			invalidNotifier.bottom = applyBtn.bottom;
			invalidNotifier.height = applyBtn.height;

			removeTitleLbl.left = PAD;
			removeTitleLbl.right = PAD;
			removeTitleLbl.top = HEADER_HEI + PAD_TOP;

			removeNoteTitleLbl.left = PAD;
			removeNoteTitleLbl.right = PAD;
			removeNoteTitleLbl.top = removeTitleLbl.y + removeTitleLbl.height + VGAP;
			removeNoteTitleLbl.bottom = FOOTER_HEI + VGAP;
		}
	}

	private function showControls():void {
		with (form) {
			titleArea.visible = false;
			descriptionArea.visible = true;
			articleBox.visible = true;
			wordInput.visible = true;
			examplesForm.visible = true;
			wordOptionsInput.visible = true;
		}
	}

}
}
