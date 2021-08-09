package de.dittner.testmyself.ui.common.audio.mp3 {
public class StoppedState implements IPlayerState {
	public function StoppedState(context:IPlayerContext) {
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
