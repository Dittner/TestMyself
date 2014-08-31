package dittner.testmyself.deutsch.service.screenFactory {
import dittner.testmyself.deutsch.view.common.screen.ScreenBase;

public interface IScreenFactory {
	function createScreen(screenId:String):ScreenBase;
	function get screenInfos():Array;
}
}
