package dittner.testmyself.deutsch.view.test.testList {
import de.dittner.async.IAsyncOperation;

import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.deutsch.model.ModuleName;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

import spark.events.IndexChangeEvent;

public class TestListMediator extends SFMediator {

	[Inject]
	public var view:TestListView;

	private static const SUBJECTS:Array = ["Wörter", "Starke Verben", "Übungen"];

	override protected function activate():void {
		view.testSubjectColl = new ArrayCollection(SUBJECTS);
		view.testSubjectList.addEventListener(IndexChangeEvent.CHANGE, onSubjectSelected);
		view.applyTestBtn.addEventListener(MouseEvent.CLICK, onTestApplied);
	}

	private function onSubjectSelected(event:IndexChangeEvent):void {
		var selectedModule:String = getModuleByTestSubject(view.testSubjectList.selectedItem);
		if (selectedModule) {
			sendRequestTo(selectedModule, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		}
		else {
			view.testInfoColl = null;
		}
	}

	private function getModuleByTestSubject(subject:String):String {
		switch (subject) {
			case "Wörter":
				return ModuleName.WORD;
			case "Starke Verben":
				return ModuleName.VERB;
			case "Übungen":
				return ModuleName.LESSON;
		}
		return "";
	}

	private function testInfoListLoaded(op:IAsyncOperation):void {
		view.testInfoColl = new ArrayCollection(op.result as Array);
	}

	private function onTestApplied(event:MouseEvent):void {
		if (view.testInfoList.selectedItem) {
			sendNotification(TestMsg.TEST_INFO_SELECTED_NOTIFICATION, view.testInfoList.selectedItem);
			sendNotification(TestMsg.SHOW_TEST_PRESETS_NOTIFICATION);
		}
	}

	override protected function deactivate():void {
		view.testSubjectList.removeEventListener(IndexChangeEvent.CHANGE, onSubjectSelected);
		view.applyTestBtn.removeEventListener(MouseEvent.CLICK, onTestApplied);
	}

}
}