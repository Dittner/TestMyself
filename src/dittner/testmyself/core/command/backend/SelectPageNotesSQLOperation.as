package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.page.NotePageInfo;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class SelectPageNotesSQLOperation extends DeferredOperation {

	public function SelectPageNotesSQLOperation(service:NoteService, pageInfo:NotePageInfo, noteClass:Class) {
		super();
		this.service = service;
		this.pageInfo = pageInfo;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var pageInfo:NotePageInfo;
	private var noteClass:Class;

	override public function process():void {
		var filter:NoteFilter = pageInfo.filter;

		var params:Object = {};
		params.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		params.amount = pageInfo.pageSize;
		params.searchFilter = filter.searchFullIdentity ? filter.searchText : "%" + filter.searchText + "%";

		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			var statement:String = service.sqlFactory.selectFilteredPageNotes;
			statement = statement.replace("#filterList", themes);
			service.sqlRunner.execute(statement, params, loadedHandler, noteClass);
		}
		else {
			service.sqlRunner.execute(service.sqlFactory.selectPageNotes, params, loadedHandler, noteClass);
		}
	}

	private function loadedHandler(result:SQLResult):void {
		pageInfo.notes = result.data is Array ? result.data as Array : [];
		dispatchCompleteSuccess(new CommandResult(pageInfo));
	}
}
}