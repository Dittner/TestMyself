package de.dittner.testmyself.ui.service.screenFactory {
import de.dittner.testmyself.ui.common.screen.ScreenBase;

public interface IScreenFactory {
	function createScreen(screenId:String):ScreenBase;
	function get screenInfos():Array;
}
}
