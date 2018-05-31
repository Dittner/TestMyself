package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.view.form.NoteFormView;
import de.dittner.testmyself.ui.view.info.InfoView;
import de.dittner.testmyself.ui.view.lessonTagList.LessonTagListView;
import de.dittner.testmyself.ui.view.main.MainView;
import de.dittner.testmyself.ui.view.map.MapView;
import de.dittner.testmyself.ui.view.noteList.NoteListView;
import de.dittner.testmyself.ui.view.noteView.NoteView;
import de.dittner.testmyself.ui.view.search.SearchView;
import de.dittner.testmyself.ui.view.settings.SettingsView;
import de.dittner.testmyself.ui.view.testList.TestListView;
import de.dittner.testmyself.ui.view.testPresets.TestPresetsView;
import de.dittner.testmyself.ui.view.testStatistics.TestStatisticsView;
import de.dittner.testmyself.ui.view.testing.TestingView;

import flash.events.Event;

import mx.events.FlexEvent;

import spark.components.Group;
import spark.transitions.ViewTransitionDirection;

public class ViewNavigator extends Group {

	//----------------------------------------------------------------------------------------------
	//
	//  Const
	//
	//----------------------------------------------------------------------------------------------

	private static const TRANSITION_DURATION_IN_FRAMES:Number = 8;

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function ViewNavigator() {
		super();
		fillViewMap();
		fillViewPosMap();
	}

	private var viewClassHash:Object = {};
	private function fillViewMap():void {
		viewClassHash[ViewID.INFO] = InfoView;
		viewClassHash[ViewID.MAP] = MapView;

		viewClassHash[ViewID.NOTE_VIEW] = NoteView;
		viewClassHash[ViewID.WORD_LIST] = NoteListView;
		viewClassHash[ViewID.VERB_LIST] = NoteListView;
		viewClassHash[ViewID.LESSON_LIST] = NoteListView;
		viewClassHash[ViewID.LESSON_TAG_LIST] = LessonTagListView;

		viewClassHash[ViewID.TEST_LIST] = TestListView;
		viewClassHash[ViewID.TEST_PRESETS] = TestPresetsView;
		viewClassHash[ViewID.TEST_STATISTICS] = TestStatisticsView;
		viewClassHash[ViewID.TESTING] = TestingView;

		viewClassHash[ViewID.SEARCH] = SearchView;
		viewClassHash[ViewID.SETTINGS] = SettingsView;

		viewClassHash[ViewID.NOTE_FORM] = NoteFormView;
	}

	private var viewPosHash:Object = {};
	private function fillViewPosMap():void {
		viewPosHash[ViewID.INFO] = 1;

		viewPosHash[ViewID.WORD_LIST] = 2;
		viewPosHash[ViewID.VERB_LIST] = 3;
		viewPosHash[ViewID.LESSON_TAG_LIST] = 4;
		viewPosHash[ViewID.LESSON_LIST] = 5;

		viewPosHash[ViewID.MAP] = 6;

		viewPosHash[ViewID.TEST_LIST] = 7;
		viewPosHash[ViewID.TEST_PRESETS] = 8;
		viewPosHash[ViewID.TEST_STATISTICS] = 9;
		viewPosHash[ViewID.TESTING] = 10;

		viewPosHash[ViewID.SEARCH] = 11;
		viewPosHash[ViewID.SETTINGS] = 12;

		viewPosHash[ViewID.NOTE_VIEW] = 13;
		viewPosHash[ViewID.NOTE_FORM] = 14;
	}

	private var viewInfoStack:Array = [];
	private const HIST_CAPACITY:int = int.MAX_VALUE;

	private var viewHash:Object = {};//[view class] = view obj;

	private var currentView:ViewBase;
	private var pendingView:ViewBase;

	private var curNavigatorAction:NavigatorAction;
	private var pendingAction:NavigatorAction;
	private var viewsTransDirection:String = "left";

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  selectedViewInfo
	//--------------------------------------
	private var _selectedViewInfo:ViewInfo;
	[Bindable("selectedViewInfoChanged")]
	public function get selectedViewInfo():ViewInfo {return _selectedViewInfo;}
	private function setSelectedViewInfo(value:ViewInfo):void {
		if (_selectedViewInfo != value) {
			_selectedViewInfo = value;
			dispatchEvent(new Event("selectedViewInfoChanged"));
		}
	}

	//--------------------------------------
	//  viewChanging
	//--------------------------------------
	private var _viewChanging:Boolean = false;
	public function get viewChanging():Boolean {return _viewChanging;}
	protected function setViewChanging(value:Boolean):void {
		if (_viewChanging != value) {
			_viewChanging = value;
			mouseEnabled = mouseChildren = !_viewChanging;
		}
	}

	//--------------------------------------
	//  mainView
	//--------------------------------------
	private var _mainView:MainView;
	[Bindable("mainViewChanged")]
	public function get mainView():MainView {return _mainView;}
	public function set mainView(value:MainView):void {
		if (_mainView != value) {
			_mainView = value;
			dispatchEvent(new Event("mainViewChanged"));
		}
	}

	override public function set width(value:Number):void {
		if (super.width != value) {
			super.width = value;
			invalidateDisplayList();
		}
	}

	override public function set height(value:Number):void {
		if (super.height != value) {
			super.height = value;
			invalidateDisplayList();
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Public Methods
	//
	//----------------------------------------------------------------------------------------------

	public function navigate(viewInfo:ViewInfo):void {
		if (getCurViewInfo() && viewPosHash[getCurViewInfo().viewID] > viewPosHash[viewInfo.viewID])
			navigateTo(viewInfo, ViewTransitionDirection.RIGHT);
		else
			navigateTo(viewInfo, ViewTransitionDirection.LEFT);
	}

	public function goBack():void {
		if (viewInfoStack.length > 1)
			navigateTo(popViewInfo(), ViewTransitionDirection.RIGHT);
	}

	public function clearViewStack():void {
		if (viewInfoStack.length > 1)
			viewInfoStack.length = 0;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function navigateTo(viewInfo:ViewInfo, direction:String = ""):void {
		if (viewInfo && getCurViewInfo() && viewInfo.viewID == getCurViewInfo().viewID) return;

		if (viewClassHash[viewInfo.viewID]) {
			addToHistory(viewInfo);
			setSelectedViewInfo(viewInfo);
			scheduleAction(viewInfo, direction);
		}
		else {
			CLog.err(LogTag.UI, "NavigationManager: view with id=" + viewInfo.viewID + " not found");
		}
	}

	private function popViewInfo():ViewInfo {
		if (viewInfoStack.length > 1) {
			viewInfoStack.pop();
			return viewInfoStack.pop();
		}
		else {
			CLog.err(LogTag.UI, "NavigationManager: prev item with index not found");
			return null;
		}
	}

	private function getCurViewInfo():ViewInfo {
		return currentView ? currentView.viewInfo : null;
	}

	private function addToHistory(viewInfo:ViewInfo):void {
		viewInfoStack.push(viewInfo);
		if (viewInfoStack.length > HIST_CAPACITY) viewInfoStack.shift();
	}

	private function scheduleAction(viewInfo:ViewInfo, direction:String = ""):void {
		if (!viewChanging && !curNavigatorAction) {
			curNavigatorAction = new NavigatorAction();
			curNavigatorAction.viewInfo = viewInfo;
			curNavigatorAction.direction = direction;
			executeCurNavigatorAction();
		}
		else {
			pendingAction = new NavigatorAction();
			pendingAction.viewInfo = viewInfo;
			pendingAction.direction = direction;
		}
	}

	private function executeCurNavigatorAction():void {
		setViewChanging(true);
		addEventListener(Event.ENTER_FRAME, prepareView);
	}

	private function prepareView(event:Event = null):void {
		if (event) removeEventListener(Event.ENTER_FRAME, prepareView);

		if (curNavigatorAction) {
			viewsTransDirection = curNavigatorAction.direction ? curNavigatorAction.direction : "left";
			pendingView = createView(curNavigatorAction.viewInfo);
			curNavigatorAction = null;

			if (pendingView) {
				addPendingViewToStage();
				if (pendingView.initialized) prepareViewTransition();
				else pendingView.addEventListener(FlexEvent.CREATION_COMPLETE, prepareViewTransition);
			}
			else setViewChanging(false);
		}
		else setViewChanging(false);
	}

	private function createView(viewInfo:ViewInfo):ViewBase {
		var res:ViewBase;
		var viewClass:Class = viewClassHash[viewInfo.viewID];
		if (!viewClass) throw new Error("Unknown screen ID:" + viewInfo.viewID);

		if (viewHash[viewInfo.viewID]) {
			res = viewHash[viewInfo.viewID];
			if (!res.cacheable) delete viewHash[viewInfo.viewID];
		}
		else {
			res = new viewClass();
			if (res.cacheable) viewHash[viewInfo.viewID] = res;
		}
		res.viewInfo = viewInfo;
		res.mainView = mainView;
		return res;
	}

	private function addPendingViewToStage():void {
		if (!currentView) pendingView.x = 0;
		else pendingView.x = viewsTransDirection == "left" ? width : -width;
		pendingView.height = height;
		pendingView.width = width;
		pendingView.width = width;
		addElement(pendingView);
	}

	private function prepareViewTransition(event:Event = null):void {
		pendingView.removeEventListener(FlexEvent.CREATION_COMPLETE, prepareViewTransition);

		if (currentView) {
			currentView.invalidate(NavigationPhase.VIEW_REMOVING);
			pendingView.invalidate(NavigationPhase.VIEW_ACTIVATING);
			playTransition();
		}
		else {
			pendingView.invalidate(NavigationPhase.VIEW_ACTIVATING);
			viewsTransitionComplete();
			setViewChanging(false);
		}
	}

	private var moveTo:int;
	private var movingFrames:int;
	private function playTransition():void {
		moveTo = viewsTransDirection == "left" ? width : -width;
		movingFrames = 0;
		addEventListener(Event.ENTER_FRAME, viewsTransiting);
	}

	private function viewsTransiting(event:Event):void {
		if (movingFrames == TRANSITION_DURATION_IN_FRAMES) {
			pendingView.x = 0;
			removeEventListener(Event.ENTER_FRAME, viewsTransiting);
			viewsTransitionComplete();
		}
		else {
			pendingView.x = moveTo * (1 - movingFrames / TRANSITION_DURATION_IN_FRAMES);
			currentView.x = pendingView.x - moveTo;
			movingFrames++;
		}
	}

	private function viewsTransitionComplete():void {
		destroyCurrentView();
		activatePendingView();
	}

	private function destroyCurrentView():void {
		if (currentView) {
			currentView.invalidate(NavigationPhase.VIEW_REMOVE);
			if (currentView.parent == this)
				removeElement(currentView);
			currentView = null;
		}
	}

	private function activatePendingView():void {
		pendingView.x = 0;
		currentView = pendingView;
		pendingView = null;
		addEventListener(Event.ENTER_FRAME, finishViewActivation);
	}

	private function finishViewActivation(event:Event):void {
		removeEventListener(Event.ENTER_FRAME, finishViewActivation);
		currentView.invalidate(NavigationPhase.VIEW_ACTIVATE);
		setViewChanging(false);
		if (pendingAction) {
			curNavigatorAction = pendingAction;
			pendingAction = null;
			executeCurNavigatorAction();
		}
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		if (currentView) {
			currentView.width = w;
			currentView.height = h;
		}

		if (pendingView) {
			pendingView.width = w;
			pendingView.height = h;
		}
	}

}
}

import de.dittner.testmyself.ui.common.view.ViewInfo;

class NavigatorAction {
	public var viewInfo:ViewInfo;
	public var direction:String = "";
}