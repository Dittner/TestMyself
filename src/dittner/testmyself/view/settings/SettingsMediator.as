package dittner.testmyself.view.settings {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.SettingsMsg;
import dittner.testmyself.model.common.SettingsInfo;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;

import flash.events.MouseEvent;

public class SettingsMediator extends RequestMediator {

	[Inject]
	public var view:SettingsScreen;

	override protected function onRegister():void {
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded));
		view.storeBtn.addEventListener(MouseEvent.CLICK, storeBtnClickHandler);
	}

	private function infoLoaded(res:CommandResult):void {
		var info:SettingsInfo = res.data as SettingsInfo;
		view.showTooltipBox.selected = info.showTooltip;
		view.pageSizeSpinner.value = info.pageSize;
		view.maxAudioRecordDurationSpinner.value = info.maxAudioRecordDuration;
	}

	private function storeBtnClickHandler(event:*):void {
		var info:SettingsInfo = new SettingsInfo();
		info.showTooltip = view.showTooltipBox.selected;
		info.pageSize = view.pageSizeSpinner.value;
		info.maxAudioRecordDuration = view.maxAudioRecordDurationSpinner.value;

		sendMessage(SettingsMsg.STORE, info);
		view.isFormChanged = false;
	}

	override protected function onRemove():void {
		view.storeBtn.removeEventListener(MouseEvent.CLICK, storeBtnClickHandler);
	}
}
}