package dittner.testmyself.deutsch.view.dictionary.lesson {
import de.dittner.async.IAsyncOperation;

import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.core.model.theme.Theme;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class LessonListMediator extends SFMediator {

	[Inject]
	public var view:LessonScreen;

	private var lessonNameHash:Object;

	override protected function activate():void {
		loadLessons();
	}

	private function loadLessons():void {
		sendRequest(NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
	}

	private function addLessonClicked(event:MouseEvent):void {
		showAddLessonForm();
	}

	private function cancelAddLessonClicked(event:MouseEvent):void {
		hideAddLessonForm();
	}

	private function applyAddLessonClicked(event:MouseEvent):void {
		if (!view.lessonColl) view.lessonColl = new ArrayCollection();
		var lesson:Theme = new Theme();
		lesson.name = view.addLessonForm.addLessonInput.text;
		sendRequest(NoteMsg.ADD_THEME, new RequestMessage(null, lesson));

		lessonNameHash[lesson.name] = true;
		view.lessonColl.addItem(lesson);
		hideAddLessonForm();
	}

	private function showAddLessonForm():void {
		if (!view.addLessonForm.visible) {
			view.addLessonForm.visible = true;
			view.addLessonForm.cancelBtn.addEventListener(MouseEvent.CLICK, cancelAddLessonClicked);
			view.addLessonForm.applyBtn.addEventListener(MouseEvent.CLICK, applyAddLessonClicked);
		}
	}

	private function hideAddLessonForm():void {
		if (view.addLessonForm.visible) {
			view.addLessonForm.visible = false;
			view.addLessonForm.addLessonInput.text = "";
			view.addLessonForm.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelAddLessonClicked);
			view.addLessonForm.applyBtn.removeEventListener(MouseEvent.CLICK, applyAddLessonClicked);
		}
	}

	private function onThemesLoaded(op:IAsyncOperation):void {
		var themeItems:Array = op.result as Array;
		view.lessonColl = new ArrayCollection(themeItems);

		lessonNameHash = {};
		for each(var theme:ITheme in themeItems) {
			lessonNameHash[theme.name] = true;
		}

		view.addLessonForm.lessonNameHash = lessonNameHash;
		view.addLessonBtn.addEventListener(MouseEvent.CLICK, addLessonClicked);
	}

	override protected function deactivate():void {
		view.addLessonBtn.removeEventListener(MouseEvent.CLICK, addLessonClicked);
		hideAddLessonForm();
		view.addLessonForm.lessonNameHash = lessonNameHash = {};
		view.addLessonForm.addLessonInput.text = "";
	}

}
}
