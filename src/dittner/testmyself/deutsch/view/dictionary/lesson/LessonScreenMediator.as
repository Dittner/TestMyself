package dittner.testmyself.deutsch.view.dictionary.lesson {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.utils.pendingInvoke.doLaterInFrames;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;

import flash.events.Event;
import flash.events.MouseEvent;

public class LessonScreenMediator extends SFMediator {

	[Inject]
	public var view:LessonScreen;

	private var lessonContentMediator:LessonContentMediator;
	private var lessonListMediator:LessonListMediator;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInFrames(activateScreen, 5);
	}

	private function activateScreen():void {
		showLessonList();
		view.lessonList.addEventListener(SelectableDataGroup.SELECTED, lessonSelectedHandler);
		view.goBackBtn.addEventListener(MouseEvent.CLICK, goBackClicked);
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function lessonSelectedHandler(event:Event):void {
		var lesson:ITheme = view.lessonList.selectedItem as ITheme;
		if (!lesson) return;
		view.selectedLessonName = lesson.name;
		sendRequest(NoteMsg.SET_FILTER, new RequestMessage(filterUpdated, null, [lesson]));
	}

	private function filterUpdated(res:CommandResult):void {
		showLessonContent();
	}

	private function showLessonContent():void {
		view.showLessonContent();
		if (lessonListMediator) {
			unregisterMediator(lessonListMediator);
			lessonListMediator = null;
		}

		if (!lessonContentMediator) {
			lessonContentMediator = new LessonContentMediator();
			registerMediator(view, lessonContentMediator);
		}
	}

	private function goBackClicked(event:MouseEvent):void {
		view.lessonList.selectedItem = null;
		showLessonList();
	}

	private function showLessonList():void {
		view.showLessonList();
		if (lessonContentMediator) {
			unregisterMediator(lessonContentMediator);
			lessonContentMediator = null;
		}

		if (!lessonListMediator) {
			lessonListMediator = new LessonListMediator();
			registerMediator(view, lessonListMediator);
		}
	}

	override protected function deactivate():void {
		view.lessonList.removeEventListener(SelectableDataGroup.SELECTED, lessonSelectedHandler);
		view.goBackBtn.removeEventListener(MouseEvent.CLICK, goBackClicked);
		view.deactivate();
		lessonListMediator = null;
		lessonContentMediator = null;
	}
}
}