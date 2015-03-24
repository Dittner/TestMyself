package dittner.testmyself.deutsch.view.dictionary.verb.form {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.model.domain.verb.IVerb;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteForm;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteFormState;

import mx.collections.ArrayCollection;

public class VerbFormState extends NoteFormState {
	public function VerbFormState(form:NoteForm) {
		this.form = form;
	}

	private var form:NoteForm;

	override public function add():void {
		showControls();
	}

	override public function edit(note:INote):void {
		var verb:IVerb = note as IVerb;
		if (form.verbInputsForm) {
			form.verbInputsForm.infinitive = verb.title;
			form.verbInputsForm.present = verb.present;
			form.verbInputsForm.past = verb.past;
			form.verbInputsForm.perfect = verb.perfect;
			form.verbInputsForm.translation = verb.description;
		}
		if (form.audioRecorder) form.audioRecorder.comment = verb.audioComment;
		showControls();
	}

	override public function remove(note:INote):void {
		form.removeNoteTitleLbl.text = '«' + note.title + '»';
	}

	override public function clear():void {
		if (form.addThemeInput) form.addThemeInput.text = "";
		if (form.audioRecorder) form.audioRecorder.clear();
		if (form.examplesForm) form.examplesForm.clear();
		if (form.verbInputsForm) form.verbInputsForm.clear();
		if (form.invalidNotifier) form.invalidNotifier.alpha = 0;
		form.themes = new ArrayCollection();
	}

	override public function updateLayout(w:Number, h:Number):void {
		with (form) {
			var firstColumnWid:Number = w - 2 * PAD - THEMES_LIST_WID - articleBox.width - 2 * HGAP;
			var formContentHeight:Number = (h - FOOTER_HEI - HEADER_HEI - PAD - PAD_TOP - RECORDER_HEI);

			verbInputsForm.x = PAD + articleBox.width + HGAP;
			verbInputsForm.y = HEADER_HEI + PAD_TOP;
			verbInputsForm.width = firstColumnWid;
			verbInputsForm.gap = VGAP;
			verbInputsForm.validateSize();
			verbInputsForm.validateDisplayList();

			examplesForm.x = PAD;
			examplesForm.y = verbInputsForm.y + verbInputsForm.height + VGAP;
			examplesForm.toolsCont.width = articleBox.width;
			examplesForm.horizontalLayout.gap = HGAP;
			examplesForm.width = w - 2 * PAD - HGAP - THEMES_LIST_WID;
			examplesForm.height = formContentHeight - examplesForm.y + HEADER_HEI + PAD_TOP;

			themesList.x = verbInputsForm.x + verbInputsForm.width + HGAP;
			themesList.y = HEADER_HEI + PAD_TOP;
			themesList.height = formContentHeight;
			themesList.width = THEMES_LIST_WID;

			audioRecorder.x = verbInputsForm.x;
			audioRecorder.y = themesList.y + themesList.height + VGAP;
			audioRecorder.width = firstColumnWid;
			audioRecorder.height = RECORDER_HEI;

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
			titleArea.visible = false;
			verbInputsForm.visible = true;
			descriptionArea.visible = false;
			articleBox.visible = false;
			wordInput.visible = false;
			examplesForm.visible = true;
			wordOptionsInput.visible = false;

			themesList.visible = true;
			addThemeBtn.visible = true;
			addThemeInput.visible = true;
		}
	}

}
}
