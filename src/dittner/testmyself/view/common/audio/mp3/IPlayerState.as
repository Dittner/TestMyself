package dittner.testmyself.view.common.audio.mp3 {
public interface IPlayerState {
	function play():void;
	function pause():void;
	function stop():void;

	function updatePlayingPosition():void;
}
}
