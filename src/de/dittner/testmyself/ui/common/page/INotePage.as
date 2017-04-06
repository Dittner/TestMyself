package de.dittner.testmyself.ui.common.page {
import de.dittner.testmyself.model.domain.tag.Tag;

import flash.events.IEventDispatcher;

import mx.collections.ArrayCollection;

public interface INotePage extends IEventDispatcher {

	[Bindable("numberChanged")]
	function get number():uint;
	function set number(value:uint):void;

	[Bindable("sizeChanged")]
	function get size():uint;

	[Bindable("allNotesAmountChanged")]
	function get allNotesAmount():int
	function set allNotesAmount(value:int):void;


	[Bindable("collChanged")]
	function get coll():ArrayCollection;
	function set coll(value:ArrayCollection):void;

	[Bindable("countAllNotesChanged")]
	function get countAllNotes():Boolean;

	[Bindable("selectedTagChanged")]
	function get selectedTag():Tag;
}
}
