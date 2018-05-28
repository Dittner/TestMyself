package de.dittner.testmyself.ui.view.form {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.ui.common.view.NoteFormViewInfo;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.ui.view.form.components.FormMode;
import de.dittner.walter.message.WalterMessage;

import flash.events.Event;

public class NoteFormVM extends ViewModel {
	public function NoteFormVM() {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  note
	//--------------------------------------
	private var _note:Note;
	[Bindable("noteChanged")]
	public function get note():Note {return _note;}
	private function setNote(value:Note):void {
		if (_note != value) {
			_note = value;
			dispatchEvent(new Event("noteChanged"));
		}
	}

	//--------------------------------------
	//  selectedFilter
	//--------------------------------------
	private var _selectedFilter:Tag;
	[Bindable("selectedFilterChanged")]
	public function get selectedFilter():Tag {return _selectedFilter;}
	private function setSelectedFilter(value:Tag):void {
		if (_selectedFilter != value) {
			_selectedFilter = value;
			dispatchEvent(new Event("selectedFilterChanged"));
		}
	}

	//--------------------------------------
	//  operation
	//--------------------------------------
	private var _operation:IAsyncOperation;
	[Bindable("operationChanged")]
	public function get operation():IAsyncOperation {return _operation;}
	private function setOperation(value:IAsyncOperation):void {
		if (_operation != value) {
			_operation = value;
			dispatchEvent(new Event("operationChanged"));
		}
	}

	//--------------------------------------
	//  hasNetworkConnection
	//--------------------------------------
	private var _hasNetworkConnection:Boolean = false;
	[Bindable("hasNetworkConnectionChanged")]
	public function get hasNetworkConnection():Boolean {return _hasNetworkConnection;}
	public function set hasNetworkConnection(value:Boolean):void {
		if (_hasNetworkConnection != value) {
			_hasNetworkConnection = value;
			dispatchEvent(new Event("hasNetworkConnectionChanged"));
		}
	}

	//--------------------------------------
	// isCreateMode
	//--------------------------------------
	[Bindable("modeChanged")]
	public function get isAddMode():Boolean {return mode == FormMode.ADD;}

	//--------------------------------------
	// isEditMode
	//--------------------------------------
	[Bindable("modeChanged")]
	public function get isEditMode():Boolean {return mode == FormMode.EDIT;}

	//--------------------------------------
	// isRemoveMode
	//--------------------------------------
	[Bindable("modeChanged")]
	public function get isRemoveMode():Boolean {return mode == FormMode.REMOVE;}

	//--------------------------------------
	//  mode
	//--------------------------------------
	private var _mode:String = "";
	[Bindable("modeChanged")]
	public function get mode():String {return _mode;}
	private function setMode(value:String):void {
		if (_mode != value) {
			_mode = value;
			notifyModeChanged();
		}
	}

	public function notifyModeChanged():void {
		dispatchEvent(new Event("modeChanged"));
	}

	//--------------------------------------
	//  isArticleEnabled
	//--------------------------------------
	private var _isArticleEnabled:Boolean = true;
	[Bindable("isArticleEnabledChanged")]
	public function get isArticleEnabled():Boolean {return _isArticleEnabled;}
	public function set isArticleEnabled(value:Boolean):void {
		if (_isArticleEnabled != value) {
			_isArticleEnabled = value;
			dispatchEvent(new Event("isArticleEnabledChanged"));
		}
	}

	//--------------------------------------
	//  isPresentVerbFormEnabled
	//--------------------------------------
	private var _isPresentVerbFormEnabled:Boolean = true;
	[Bindable("isPresentVerbFormEnabledChanged")]
	public function get isPresentVerbFormEnabled():Boolean {return _isPresentVerbFormEnabled;}
	public function set isPresentVerbFormEnabled(value:Boolean):void {
		if (_isPresentVerbFormEnabled != value) {
			_isPresentVerbFormEnabled = value;
			dispatchEvent(new Event("isPresentVerbFormEnabledChanged"));
		}
	}

	//--------------------------------------
	//  isOptionalTemplatesEnabled
	//--------------------------------------
	private var _isOptionalTemplatesEnabled:Boolean = true;
	[Bindable("isOptionalTemplatesEnabledChanged")]
	public function get isOptionalTemplatesEnabled():Boolean {return _isOptionalTemplatesEnabled;}
	public function set isOptionalTemplatesEnabled(value:Boolean):void {
		if (_isOptionalTemplatesEnabled != value) {
			_isOptionalTemplatesEnabled = value;
			dispatchEvent(new Event("isOptionalTemplatesEnabledChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(viewInfo:ViewInfo):void {
		super.viewActivated(viewInfo);
		if (viewInfo is NoteFormViewInfo) {
			setMode((viewInfo as NoteFormViewInfo).formMode);
			setNote((viewInfo as NoteFormViewInfo).note);
			setSelectedFilter((viewInfo as NoteFormViewInfo).filter);
			setOperation((viewInfo as NoteFormViewInfo).callback);

			isArticleEnabled = appModel.selectedLanguage.id == LanguageID.DE;
			isPresentVerbFormEnabled = appModel.selectedLanguage.id == LanguageID.DE;
			isOptionalTemplatesEnabled = appModel.selectedLanguage.id == LanguageID.DE;
			hasNetworkConnection = appModel.hasNetworkConnection;
			listenProxy(appModel, AppModel.NETWORK_CONNECTION_CHANGED_MSG, networkConnectionChanged);
		}
		else {
			throw new Error("Expected NoteFormViewInfo, but received: " + viewInfo);
		}
	}

	private function networkConnectionChanged(msg:WalterMessage):void {
		hasNetworkConnection = msg.data;
	}

}
}