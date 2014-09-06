package dittner.testmyself.core.model.audioComment {
import flash.utils.ByteArray;

[RemoteClass(alias="dittner.testmyself.core.model.audioComment.AudioComment")]
public class AudioComment {
	public function AudioComment() {
		super();
	}

	public var bytes:ByteArray;
	public var isMp3:Boolean = false;
}
}
