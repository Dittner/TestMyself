package dittner.testmyself.deutsch.view.note.form.word {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.note.form.*;

import mx.collections.ArrayCollection;

public class WordFormState extends NoteFormState {
	public function WordFormState(form:NoteForm) {
		this.form = form;
	}

	private var form:NoteForm;

	override public function edit(note:INote):void {
		if (form.titleArea) form.titleArea.text = note.title;
		if (form.descriptionArea) form.descriptionArea.text = note.description;
		if (form.audioRecorder) form.audioRecorder.mp3Data = note.audioComment;
	}

	override public function remove(note:INote):void {
		form.removeNoteTitleLbl.text = '«' + note.title + '»';
	}

	override public function clear():void {
		if (form.titleArea) form.titleArea.text = "";
		if (form.descriptionArea) form.descriptionArea.text = "";
		if (form.addThemeInput) form.addThemeInput.text = "";
		if (form.audioRecorder) form.audioRecorder.clear();
		form.themes = new ArrayCollection();
	}

	override public function updateLayout(w:Number, h:Number):void {
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

}
}
