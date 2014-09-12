package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.page.PageInfo;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;

public class SelectNoteSQLOperation extends DeferredOperation {

	public function SelectNoteSQLOperation(service:NoteService, pageInfo:PageInfo, noteClass:Class) {
		super();
		this.service = service;
		this.pageInfo = pageInfo;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var pageInfo:PageInfo;
	private var noteClass:Class;

	override public function process():void {
		var params:Object = {};
		params.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		params.amount = pageInfo.pageSize;

		if (pageInfo.filter.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(pageInfo.filter);
			var statement:String = service.sqlFactory.selectFilteredNote;
			statement = statement.replace("#filterList", themes);
			service.sqlRunner.execute(statement, params, loadedHandler, noteClass);
		}
		else {
			service.sqlRunner.execute(service.sqlFactory.selectNote, params, loadedHandler, noteClass);
		}
	}

	private function loadedHandler(result:SQLResult):void {
		pageInfo.notes = result.data is Array ? result.data as Array : [];
		dispatchCompleteSuccess(new CommandResult(pageInfo));
	}
}
}