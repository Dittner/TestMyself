package dittner.testmyself.deutsch.view.common.renderer {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.model.search.FoundNote;
import dittner.testmyself.deutsch.view.dictionary.note.list.NoteRendererData;
import dittner.testmyself.deutsch.view.test.common.TestRendererData;

import flash.display.Graphics;

public class NoteBaseRenderer extends ItemRendererBase {

	public function NoteBaseRenderer() {
		super();
	}

	protected function hasAudioComment():Boolean {
		if (data is INote && (data as INote).audioComment.bytes) return true;
		else if (data is TestRendererData && (data as TestRendererData).note.audioComment.bytes) return true;
		else if (data is FoundNote && (data as FoundNote).note.audioComment.bytes) return true;
		else return (data is NoteRendererData && (data as NoteRendererData).note.audioComment.bytes);
	}

	protected function showNoAudioNotification():void {
		/*var symSize:uint = 16;
		 var lineWid:uint = 2;
		 var centerX:int = 20 - lineWid;
		 var centerY:int = lineWid;
		 var g:Graphics = graphics;
		 g.lineStyle(lineWid, selected ? 0xffFFff : 0, 0.1);
		 g.moveTo(centerX, centerY + symSize / 2);
		 g.curveTo(centerX, centerY, centerX + symSize / 2, centerY);

		 centerX += symSize / 5;
		 centerY += symSize / 5;
		 symSize /= 1.6;
		 g.moveTo(centerX, centerY + symSize / 2);
		 g.curveTo(centerX, centerY, centerX + symSize / 2, centerY);

		 centerX += symSize / 3;
		 centerY += symSize / 3;
		 symSize /= 2.2;
		 g.moveTo(centerX, centerY + symSize / 2);
		 g.curveTo(centerX, centerY, centerX + symSize / 2, centerY);*/

		if (!selected) {
			var g:Graphics = graphics;
			g.beginFill(0xfcfafe);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
	}

	protected function showNoAudioNotificationForExample():void {
		if (!selected) {
			var g:Graphics = graphics;
			g.beginFill(0xe8e5eb);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
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
