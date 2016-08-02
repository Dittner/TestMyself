package de.dittner.testmyself.ui.common.page {
import mx.collections.ArrayCollection;

public interface INotePage {
	function get number():uint;
	function get size():uint;
	function get allNotesAmount():int
	function set allNotesAmount(value:int):void;
	function get noteColl():ArrayCollection;
	function set noteColl(value:ArrayCollection):void;
	function get countAllNotes():Boolean;
}
}
