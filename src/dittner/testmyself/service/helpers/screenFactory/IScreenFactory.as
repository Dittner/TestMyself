package dittner.testmyself.service.helpers.screenFactory {
import dittner.testmyself.view.core.ScreenBase;

public interface IScreenFactory {
	function generate(screenId:uint):ScreenBase;
	function generateFirstScreen():ScreenBase;
	function get screenInfos():Array;
}
}
