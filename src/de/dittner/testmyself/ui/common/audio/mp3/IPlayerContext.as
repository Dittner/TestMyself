package de.dittner.testmyself.ui.common.audio.mp3 {
import flash.media.Sound;

public interface IPlayerContext {
	function get curState():IPlayerState;
	function set curState(value:IPlayerState):void;

	function get sound():Sound;

	function getPlayingState():IPlayerState;
	function getPausedState():IPlayerState;
	function getStoppedState():IPlayerState;

	function updatePlayback(sec:Number):void;
	function get playbackTime():Number;

}
}
