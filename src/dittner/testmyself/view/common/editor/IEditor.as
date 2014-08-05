package dittner.testmyself.view.common.editor {
import dittner.testmyself.model.common.LanguageUnitVo;

import mx.collections.ArrayCollection;
import mx.core.IVisualElement;

public interface IEditor extends IVisualElement {

	function add():void;
	function edit(vo:LanguageUnitVo):void;
	function remove(vo:LanguageUnitVo):void;
	function close():void;
	function notifyInvalidData(msg:String):void

	function get themes():ArrayCollection;
	function set themes(value:ArrayCollection):void;
}
}
