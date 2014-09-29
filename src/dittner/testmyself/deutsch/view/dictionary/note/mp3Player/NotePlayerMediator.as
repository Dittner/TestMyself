package dittner.testmyself.deutsch.view.dictionary.note.mp3Player {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.common.audio.mp3.MP3Player;

public class NotePlayerMediator extends SFMediator {

	[Inject]
	public var view:MP3Player;

	private var selectedNote:INote;
	private var selectedExample:INote;

	override protected function activate():void {
		addListener(NoteMsg.NOTE_SELECTED_NOTIFICATION, noteSelectedHandler);
		addListener(NoteMsg.EXAMPLE_SELECTED_NOTIFICATION, exampleSelectedHandler);
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