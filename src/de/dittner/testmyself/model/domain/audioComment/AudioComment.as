package de.dittner.testmyself.model.domain.audioComment {
import flash.utils.ByteArray;

[RemoteClass(alias="de.dittner.testmyself.core.model.audioComment.AudioComment")]
public class AudioComment {
	public function AudioComment() {
		super();
	}

	public var bytes:ByteArray;
	public var isMp3:Boolean = false;
	public function get isEmpty():Boolean {return !bytes || bytes.length == 0;}
}
}
