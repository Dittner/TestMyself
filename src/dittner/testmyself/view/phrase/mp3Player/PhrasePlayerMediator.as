package dittner.testmyself.view.phrase.mp3Player {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.IPhrase;
import dittner.testmyself.view.common.audio.mp3.MP3Player;

import mvcexpress.mvc.Mediator;

public class PhrasePlayerMediator extends Mediator {

	[Inject]
	public var view:MP3Player;

	override protected function onRegister():void {
		addHandler(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, phraseSelectedHandler);
	}

	private function phraseSelectedHandler(phrase:IPhrase):void {
		view.audioComment = phrase.audioRecord;
		view.visible = phrase.audioRecord != null;
	}

	override protected function onRemove():void {
		removeAllHandlers();
	}

}
}