package dittner.testmyself.core.message {
public class NoteMsg {

	public static const THEMES_CHANGED_NOTIFICATION:String = "themesChangedNotification";
	public static const PAGE_INFO_CHANGED_NOTIFICATION:String = "pageInfoChangedNotification";
	public static const NOTES_INFO_CHANGED_NOTIFICATION:String = "notesInfoChangedNotification";
	public static const NOTE_SELECTED_NOTIFICATION:String = "noteSelectedNotification";

	public static const SELECT_NOTE:String = "selectNote";

	public static const TOOL_ACTION_SELECTED_NOTIFICATION:String = "toolActionSelectedNotification";

	public static const FORM_ACTIVATED_NOTIFICATION:String = "formActivatedNotification";
	public static const FORM_DEACTIVATED_NOTIFICATION:String = "formDeactivatedNotification";

	public static const GET_PAGE_INFO:String = "getPageInfo";
	public static const CLEAR_NOTES_INFO:String = "clearNotesInfo";
	public static const GET_SELECTED_NOTE:String = "getSelectedNote";
	public static const GET_FILTER:String = "getFilter";
	public static const SET_FILTER:String = "setFilter";

	/*SQL*/
	public static const ADD_NOTE:String = "addNote";
	public static const UPDATE_NOTE:String = "updateNote";
	public static const REMOVE_NOTE:String = "removeNote";
	public static const GET_THEMES:String = "getThemes";
	public static const GET_EXAMPLES:String = "getExamples";
	public static const UPDATE_THEME:String = "updateTheme";
	public static const REMOVE_THEME:String = "removeTheme";
	public static const MERGE_THEMES:String = "mergeThemes";
	public static const GET_SELECTED_THEMES_ID:String = "getSelectedThemesID";
	public static const GET_NOTES_INFO:String = "getNotesInfo";

}
}