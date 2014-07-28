package dittner.testmyself.service.helpers.screenFactory {
import dittner.testmyself.view.common.screen.ScreenBase;

public interface IScreenFactory {
	function generate(screenId:uint):ScreenBase;
	function generateFirstScreen():ScreenBase;
	function get screens():Array;
}
}
