package dittner.testmyself.view.settings {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.SettingsMsg;
import dittner.testmyself.model.common.SettingsInfo;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;

public class SettingsMediator extends RequestMediator {

	[Inject]
	public var view:SettingsScreen;

	override protected function onRegister():void {
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded))
	}

	private function infoLoaded(res:CommandResult):void {
		var info:SettingsInfo = res.data as SettingsInfo;
		view.showTooltipBox.selected = info.showTooltips;
		view.transUnitsPerPageSpinner.value = info.transUnitsPerPage;
		view.maxAudioRecorDurationSpinner.value = info.maxAudioRecordDuration;
	}

	override protected function onRemove():void {
		var info:SettingsInfo = new SettingsInfo();
		info.showTooltips = view.showTooltipBox.selected;
		info.transUnitsPerPage = view.transUnitsPerPageSpinner.value;
		info.maxAudioRecordDuration = view.maxAudioRecorDurationSpinner.value;

		sendMessage(SettingsMsg.STORE, info);
	}
}
}