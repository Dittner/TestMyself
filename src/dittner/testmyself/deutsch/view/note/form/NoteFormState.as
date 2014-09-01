package dittner.testmyself.deutsch.view.note.form {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.common.editor.EditorBg;
import dittner.testmyself.deutsch.view.common.utils.AppSizes;

public class NoteFormState {
	public function NoteFormState() {}

	protected const HEADER_HEI:uint = EditorBg.HEADER_HEIGHT;
	protected const FOOTER_HEI:uint = AppSizes.EDITOR_FOOTER_HEIGHT;
	protected const PAD:uint = 20;
	protected const PAD_TOP:uint = 10;
	protected const HGAP:uint = 10;
	protected const VGAP:uint = 5;
	protected const THEMES_LIST_WID:uint = 250;
	protected const RECORDER_HEI:uint = 72;
	protected const BORDER_THICKNESS:uint = EditorBg.BORDER_THICKNESS;

	public function add():void {}
	public function edit(note:INote):void {}
	public function remove(note:INote):void {}
	public function clear():void {}
	public function updateLayout(w:Number, h:Number):void {}

}
}
