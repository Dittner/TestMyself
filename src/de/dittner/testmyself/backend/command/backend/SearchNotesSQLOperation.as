package de.dittner.testmyself.backend.command.backend {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.NoteService;
import de.dittner.testmyself.backend.command.backend.utils.SQLUtils;
import de.dittner.testmyself.model.search.FoundNote;
import de.dittner.testmyself.model.search.SearchSpec;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SearchNotesSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function SearchNotesSQLOperation(service:NoteService, searchSpec:SearchSpec) {
		super();
		this.service = service;
		this.searchSpec = searchSpec;
	}

	private var service:NoteService;
	private var searchSpec:SearchSpec;

	public function execute():void {
		var sql:String = searchSpec.needExample ? service.sqlFactory.searchNoteExamples : service.sqlFactory.searchNotes;
		var sqlParams:Object = {};
		var searchText:String;

		searchText = searchSpec.searchText.charAt(0).toLowerCase() + searchSpec.searchText.substring(1, searchSpec.searchText.length);
		sqlParams.searchFilter1 = "%" + searchText + "%";
		searchText = searchSpec.searchText.charAt(0).toUpperCase() + searchSpec.searchText.substring(1, searchSpec.searchText.length);
		sqlParams.searchFilter2 = "%" + searchText + "%";

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = service.sqlConnection;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
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
		dispatchSuccess(fnotes);
	}
}
}