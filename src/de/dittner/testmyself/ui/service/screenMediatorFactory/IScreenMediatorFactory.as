package de.dittner.testmyself.ui.service.screenMediatorFactory {
import de.dittner.satelliteFlight.mediator.SFMediator;

public interface IScreenMediatorFactory {
	function createScreenMediator(screenId:String):SFMediator;
}
}
