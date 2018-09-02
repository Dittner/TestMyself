package de.dittner.testmyself.ui.view.lessonTagList {
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.NotePage;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

public class LessonTagListVM extends ViewModel {

	public function LessonTagListVM() {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  page
	//--------------------------------------
	private var _page:NotePage;
	[Bindable("pageChanged")]
	public function get page():NotePage {return _page;}
	private function setPage(value:NotePage):void {
		if (_page != value) {
			_page = value;
			dispatchEvent(new Event("pageChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(viewInfo:ViewInfo):void {
		super.viewActivated(viewInfo);
		setPage(appModel.getLessonPage());
		dispatchEvent(new Event("pageChanged"));
	}

	public function showNoteList(selectedTag:Tag):void {
		page.number = 0;
		page.countAllNotes = true;
		var info:ViewInfo = new ViewInfo();
		info.viewID = ViewID.LESSON_LIST;
		info.menuViewID = viewInfo.menuViewID;
		info.page = page;
		info.page.selectedTag = selectedTag;
		navigateTo(info);
	}
}
}