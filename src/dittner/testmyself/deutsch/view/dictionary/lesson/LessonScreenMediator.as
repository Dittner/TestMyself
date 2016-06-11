package dittner.testmyself.deutsch.view.dictionary.lesson {
import de.dittner.async.IAsyncOperation;
import de.dittner.async.utils.doLaterInFrames;

import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;

import flash.events.Event;
import flash.events.MouseEvent;

public class LessonScreenMediator extends SFMediator {

	[Inject]
	public var view:LessonScreen;

	private var lessonContentMediator:LessonContentMediator;
	private var lessonListMediator:LessonListMediator;
	private var filter:NoteFilter;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInFrames(activateScreen, 5);
	}

	private function activateScreen():void {
		showLessonList();
		loadFilter();
	}

	private function loadFilter():void {
		sendRequest(NoteMsg.GET_FILTER, new RequestMessage(onFilterLoaded));
	}

	private function onFilterLoaded(op:IAsyncOperation):void {
		filter = op.result as NoteFilter;
		view.lessonList.addEventListener(SelectableDataGroup.SELECTED, lessonSelectedHandler);
		view.goBackBtn.addEventListener(MouseEvent.CLICK, goBackClicked);
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function lessonSelectedHandler(event:Event):void {
		if (!filter) return;

		var lesson:ITheme = view.lessonList.selectedItem as ITheme;
		if (!lesson) return;
		view.selectedLessonName = lesson.name;
		filter.selectedThemes = [lesson];
		sendRequest(NoteMsg.SET_FILTER, new RequestMessage(filterUpdated, filter));
	}

	private function filterUpdated(op:IAsyncOperation):void {
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
		view.lessonList.selectedItem = null;
	}
}
}