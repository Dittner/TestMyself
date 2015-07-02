package dittner.testmyself.deutsch.view.common.renderer {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.model.search.FoundNote;
import dittner.testmyself.deutsch.view.dictionary.note.list.NoteRendererData;
import dittner.testmyself.deutsch.view.test.common.TestRendererData;

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
		soundIcon.y = 5;
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
