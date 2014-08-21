package dittner.testmyself.view.settings {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.SettingsMsg;
import dittner.testmyself.model.common.SettingsInfo;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.settings.phraseSettings.PhraseSettingsMediator;

public class SettingsMediator extends RequestMediator {

	[Inject]
	public var view:SettingsScreen;

	override protected function onRegister():void {
		view.clear();
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded));
		mediatorMap.mediateWith(view.phraseSettings, PhraseSettingsMediator);
	}

	private function infoLoaded(res:CommandResult):void {
		var info:SettingsInfo = res.data as SettingsInfo;
		view.commonSettings.showTooltipBox.selected = info.showTooltip;
		view.commonSettings.maxAudioRecordDurationSpinner.value = info.maxAudioRecordDuration;
	}

	override protected function onRemove():void {
		mediatorMap.unmediate(view.phraseSettings, PhraseSettingsMediator);

		var info:SettingsInfo = new SettingsInfo();
		info.showTooltip = view.commonSettings.showTooltipBox.selected;
		info.maxAudioRecordDuration = view.commonSettings.maxAudioRecordDurationSpinner.value;
		info.phrasePageSize = view.phraseSettings.pageSizeSpinner.value;

		sendMessage(SettingsMsg.STORE, info);
	}
}
}