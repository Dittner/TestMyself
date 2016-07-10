package de.dittner.testmyself.ui.view.dictionary.note.mp3Player {
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.backend.message.SearchMsg;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.search.FoundNote;
import de.dittner.testmyself.ui.common.audio.mp3.MP3Player;

public class NotePlayerMediator extends SFMediator {

	[Inject]
	public var view:MP3Player;

	private var selectedNote:INote;
	private var selectedExample:INote;

	override protected function activate():void {
		addListener(SearchMsg.SELECTED_NOTE_NOTIFICATION, foundNoteSelectedHandler);
		addListener(NoteMsg.NOTE_SELECTED_NOTIFICATION, noteSelectedHandler);
		addListener(NoteMsg.EXAMPLE_SELECTED_NOTIFICATION, exampleSelectedHandler);
	}

	private function foundNoteSelectedHandler(fnote:FoundNote):void {
		noteSelectedHandler(fnote ? fnote.note : null);
	}

	private function noteSelectedHandler(note:INote):void {
		selectedNote = note;
		selectedExample = null;
		updatePlayerComment();
	}

	private function exampleSelectedHandler(note:INote):void {
		selectedExample = note;
		updatePlayerComment();
	}

	private function updatePlayerComment():void {
		if (selectedExample && hasAudioComment(selectedExample)) {
			view.comment = selectedExample.audioComment;
			view.visible = true;
		}
		else if (selectedNote && hasAudioComment(selectedNote)) {
			view.comment = selectedNote.audioComment;
			view.visible = true;
		}
		else {
			view.comment = null;
			view.visible = false;
		}
	}

	private function hasAudioComment(note:INote):Boolean {
		return note && note.audioComment.bytes;
	}

	override protected function deactivate():void {
		selectedNote = null;
		selectedExample = null;
		view.comment = null;
		view.visible = false;
	}

}
}