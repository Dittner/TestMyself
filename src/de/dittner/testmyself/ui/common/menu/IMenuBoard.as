package de.dittner.testmyself.ui.common.menu {
import flash.events.IEventDispatcher;

public interface IMenuBoard extends IEventDispatcher {
	function showViewMenu():void;
	function showFormMenu():void;
	function showTestMenu():void;
	function hideFormMenu():void;
	function hideTestMenu():void;

	function get taskPriority():uint;
	function set taskPriority(value:uint):void;
}
}
