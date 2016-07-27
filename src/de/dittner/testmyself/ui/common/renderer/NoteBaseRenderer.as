package de.dittner.testmyself.ui.common.renderer {
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.test.TestTask;

import flash.display.DisplayObject;

public class NoteBaseRenderer extends ItemRendererBase {

	public function NoteBaseRenderer() {
		super();
	}

	[Embed(source='/assets/sound_icon.png')]
	private static const SoundIconClass:Class;
	protected var soundIcon:DisplayObject;

	override protected function createChildren():void {
		super.createChildren();
		if (!soundIcon) {
			soundIcon = new SoundIconClass();
			soundIcon.visible = false;
			addChild(soundIcon);
		}
	}

	protected function hasAudioComment():Boolean {
		if (data is INote && (data as INote).audioComment.bytes) return true;
		else if (data is TestTask && (data as TestTask).note.audioComment.bytes) return true;
	}

	protected function updateSoundIconPos(w:Number, h:Number):void {
		soundIcon.x = w - soundIcon.width - 10;
		soundIcon.y = h - soundIcon.height >> 1;
		soundIcon.visible = hasAudioComment();
	}

	override public function set selected(value:Boolean):void {
		super.selected = value;
		dataChanged = true;
		invalidateProperties();
		invalidateSize();
		invalidateDisplayList();
	}

}
}
