package dittner.testmyself.deutsch.view.note.mp3Player {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.common.audio.mp3.MP3Player;

public class NotePlayerMediator extends SFMediator {

	[Inject]
	public var view:MP3Player;

	override protected function activate():void {
		addListener(NoteMsg.NOTE_SELECTED_NOTIFICATION, noteSelectedHandler);
	}

	private function noteSelectedHandler(note:INote):void {
		view.comment = note ? note.audioComment : null;
		view.visible = note && note.audioComment.bytes;
	}

	override protected function deactivate():void {}

}
}