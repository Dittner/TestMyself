package dittner.testmyself.deutsch.service.screenMediatorFactory {
import dittner.satelliteFlight.mediator.SFMediator;

public interface IScreenMediatorFactory {
	function createScreenMediator(screenId:String):SFMediator;
}
}
