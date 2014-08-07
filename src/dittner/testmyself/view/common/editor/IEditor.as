package dittner.testmyself.view.common.editor {
import dittner.testmyself.model.common.TransUnit;

import mx.collections.ArrayCollection;
import mx.core.IVisualElement;

public interface IEditor extends IVisualElement {

	function add():void;
	function edit(vo:TransUnit):void;
	function remove(vo:TransUnit):void;
	function close():void;
	function notifyInvalidData(msg:String):void

	function get themes():ArrayCollection;
	function set themes(value:ArrayCollection):void;
}
}
