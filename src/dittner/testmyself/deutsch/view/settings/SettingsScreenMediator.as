package dittner.testmyself.deutsch.view.settings {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.message.SettingsMsg;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.settings.SettingsInfo;
import dittner.testmyself.deutsch.view.settings.noteSettings.LessonSettingsMediator;
import dittner.testmyself.deutsch.view.settings.noteSettings.VerbSettingsMediator;
import dittner.testmyself.deutsch.view.settings.noteSettings.WordSettingsMediator;
import dittner.testmyself.deutsch.view.settings.testSettings.TestSettingsMediator;

public class SettingsScreenMediator extends SFMediator {

	[Inject]
	public var view:SettingsScreen;

	override protected function activate():void {
		view.clear();
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded));
		registerMediator(view.wordSettings, new WordSettingsMediator());
		registerMediator(view.verbSettings, new VerbSettingsMediator());
		registerMediator(view.lessonSettings, new LessonSettingsMediator());
		registerMediator(view.testSettings, new TestSettingsMediator());
	}

	private function infoLoaded(res:CommandResult):void {
		var info:SettingsInfo = res.data as SettingsInfo;
		view.commonSettings.showTooltipBox.selected = info.showTooltip;
		view.commonSettings.maxAudioRecordDurationSpinner.value = info.maxAudioRecordDuration;
		view.commonSettings.pageSizeSpinner.value = info.pageSize;
	}

	override protected function deactivate():void {
		var info:SettingsInfo = new SettingsInfo();
		info.showTooltip = view.commonSettings.showTooltipBox.selected;
		info.maxAudioRecordDuration = view.commonSettings.maxAudioRecordDurationSpinner.value;
		info.pageSize = view.commonSettings.pageSizeSpinner.value;

		sendRequest(SettingsMsg.STORE, new RequestMessage(null, null, info));
		sendRequestTo(ModuleName.WORD, NoteMsg.CLEAR_NOTES_INFO, new RequestMessage());
		sendRequestTo(ModuleName.VERB, NoteMsg.CLEAR_NOTES_INFO, new RequestMessage());
	}

}
}