package dittner.testmyself.deutsch.view.dictionary.phrase.form {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteForm;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteFormState;

import mx.collections.ArrayCollection;

public class PhraseFormState extends NoteFormState {
	public function PhraseFormState(form:NoteForm) {
		this.form = form;
	}

	private var form:NoteForm;

	override public function edit(note:INote):void {
		if (form.titleArea) form.titleArea.text = note.title;
		if (form.descriptionArea) form.descriptionArea.text = note.description;
		if (form.audioRecorder) form.audioRecorder.comment = note.audioComment;
	}

	override public function remove(note:INote):void {
		form.removeNoteTitleLbl.text = '«' + note.title + '»';
	}

	override public function clear():void {
		if (form.titleArea) form.titleArea.text = "";
		if (form.descriptionArea) form.descriptionArea.text = "";
		if (form.addThemeInput) form.addThemeInput.text = "";
		if (form.audioRecorder) form.audioRecorder.clear();
		if (form.invalidNotifier) form.invalidNotifier.alpha = 0;
		form.themes = new ArrayCollection();
	}

	override public function updateLayout(w:Number, h:Number):void {
		showControls();
		with (form) {
			titleArea.x = PAD;
			titleArea.y = HEADER_HEI + PAD_TOP;
			titleArea.height = (h - FOOTER_HEI - HEADER_HEI - PAD - PAD_TOP - 2 * VGAP - RECORDER_HEI) / 2;
			titleArea.width = w - 2 * PAD - HGAP - THEMES_LIST_WID;

			descriptionArea.x = titleArea.x;
			descriptionArea.y = titleArea.y + titleArea.height + VGAP;
			descriptionArea.height = titleArea.height;
			descriptionArea.width = titleArea.width;

			audioRecorder.x = PAD;
			audioRecorder.y = titleArea.y + 2 * titleArea.height + 2 * VGAP;
			audioRecorder.width = titleArea.width;
			audioRecorder.height = RECORDER_HEI;

			themesList.x = descriptionArea.x + descriptionArea.width + HGAP;
			themesList.y = HEADER_HEI + PAD_TOP;
			themesList.height = 2 * titleArea.height + VGAP;
			themesList.width = THEMES_LIST_WID;

			addThemeInput.x = themesList.x;
			addThemeInput.y = themesList.y + themesList.height + VGAP;
			addThemeInput.width = themesList.width - addThemeBtn.width + 1;

			addThemeBtn.x = addThemeInput.x + addThemeInput.width - 1;
			addThemeBtn.y = addThemeInput.y + 20;

			applyBtn.width = THEMES_LIST_WID;
			applyBtn.x = themesList.x;
			applyBtn.y = h - (FOOTER_HEI - applyBtn.height + BORDER_THICKNESS) / 2 - applyBtn.height;

			cancelBtn.x = applyBtn.x - THEMES_LIST_WID - HGAP;
			cancelBtn.y = applyBtn.y;
			cancelBtn.width = THEMES_LIST_WID;

			invalidNotifier.x = PAD;
			invalidNotifier.y = applyBtn.y;
			invalidNotifier.width = cancelBtn.x - invalidNotifier.x - HGAP;
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
			titleArea.visible = true;
			descriptionArea.visible = true;
			articleBox.visible = false;
			verbInputsForm.visible = false;
			wordInput.visible = false;
			examplesForm.visible = false;
			wordOptionsInput.visible = false;

			themesList.visible = true;
			addThemeBtn.visible = true;
			addThemeInput.visible = true;
		}
	}

}
}
