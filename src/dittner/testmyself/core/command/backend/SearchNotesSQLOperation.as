package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.service.NoteService;
import dittner.testmyself.deutsch.model.search.FoundNote;
import dittner.testmyself.deutsch.model.search.SearchSpec;

import flash.data.SQLResult;

public class SearchNotesSQLOperation extends DeferredOperation {

	public function SearchNotesSQLOperation(service:NoteService, searchSpec:SearchSpec) {
		super();
		this.service = service;
		this.searchSpec = searchSpec;
	}

	private var service:NoteService;
	private var searchSpec:SearchSpec;

	override public function process():void {
		var sql:String = searchSpec.needExample ? service.sqlFactory.searchNoteExamples : service.sqlFactory.searchNotes;
		var params:Object = {};
		var searchText:String;

		searchText = searchSpec.searchText.charAt(0).toLowerCase() + searchSpec.searchText.substring(1, searchSpec.searchText.length);
		params.searchFilter1 = "%" + searchText + "%";
		searchText = searchSpec.searchText.charAt(0).toUpperCase() + searchSpec.searchText.substring(1, searchSpec.searchText.length);
		params.searchFilter2 = "%" + searchText + "%";
		service.sqlRunner.execute(sql, params, loadedHandler);
	}

	private function loadedHandler(result:SQLResult):void {
		var fnotes:Array = [];
		var fnote:FoundNote;
		var ids:Array = result.data is Array ? result.data as Array : [];
		var idHash:Object = {};
		for each(var item:Object in ids) {
			if (idHash[item.id]) continue;
			idHash[item.id] = true;
			fnote = new FoundNote();
			fnote.moduleName = service.moduleName;
			fnote.noteID = item.id;
			fnote.isExample = searchSpec.needExample;
			fnotes.push(fnote);
		}
		dispatchCompleteSuccess(new CommandResult(fnotes));
	}
}
}