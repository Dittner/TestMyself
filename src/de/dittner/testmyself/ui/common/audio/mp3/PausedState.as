package de.dittner.testmyself.ui.common.audio.mp3 {
public class PausedState implements IPlayerState {
	public function PausedState(context:IPlayerContext) {
		this.context = context;
	}

	private var context:IPlayerContext;

	public function play():void {
		context.curState = context.getPlayingState();
		context.curState.play();
	}

	public function pause():void {}

	public function stop():void {}

	public function updatePlayingPosition():void {}

}
}
