package de.dittner.testmyself.ui.common.renderer {
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.search.FoundNote;
import de.dittner.testmyself.ui.view.test.common.TestRendererData;
import de.dittner.testmyself.ui.view.vocabulary.note.list.NoteRendererData;

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
		else if (data is TestRendererData && (data as TestRendererData).note.audioComment.bytes) return true;
		else if (data is FoundNote && (data as FoundNote).note.audioComment.bytes) return true;
		else return (data is NoteRendererData && (data as NoteRendererData).note.audioComment.bytes);
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
