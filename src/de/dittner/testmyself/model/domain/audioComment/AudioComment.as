package de.dittner.testmyself.model.domain.audioComment {
import de.dittner.testmyself.ui.common.audio.mp3.MP3Player;

import flash.utils.ByteArray;

[RemoteClass(alias="de.dittner.testmyself.core.model.audioComment.AudioComment")]
public class AudioComment {
	public function AudioComment() {
		super();
	}

	public static const PLAYER:MP3Player = new MP3Player();

	public var bytes:ByteArray;
	public var isMp3:Boolean = false;
	public function get isEmpty():Boolean {return !bytes || bytes.length == 0;}

	public function play():void {
		if (isMp3 && bytes && bytes.length > 0) {
			PLAYER.comment = this;
			PLAYER.play();
		}
	}
}
}
