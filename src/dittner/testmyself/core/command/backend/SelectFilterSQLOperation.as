package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLFactory;

import flash.data.SQLResult;

public class SelectFilterSQLOperation extends DeferredOperation {

	public function SelectFilterSQLOperation(sqlRunner:SQLRunner, noteID:int, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.noteID = noteID;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var noteID:int;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		if (noteID) {
			sqlRunner.execute(sqlFactory.selectFilter, {selectedNoteID: noteID}, loadCompleteHandler);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID единицы перевода"));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var themesID:Array = [];
		for each(var item:Object in result.data) themesID.push(item.themeID);
		dispatchCompleteSuccess(new CommandResult(themesID));
	}
}
}