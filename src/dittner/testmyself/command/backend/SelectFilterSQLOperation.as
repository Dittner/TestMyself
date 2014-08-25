package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.command.backend.utils.SQLFactory;

import flash.data.SQLResult;

public class SelectFilterSQLOperation extends DeferredOperation {

	public function SelectFilterSQLOperation(sqlRunner:SQLRunner, transUnitID:int, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.transUnitID = transUnitID;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var transUnitID:int;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		if (transUnitID) {
			sqlRunner.execute(sqlFactory.selectFilter, {selectedTransUnitID: transUnitID}, loadCompleteHandler);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.NULL_TRANS_UNIT, "Отсутствует ID единицы перевода"));
		}
	}

	private function loadCompleteHandler(result:SQLResult):void {
		var themesID:Array = [];
		for each(var item:Object in result.data) themesID.push(item.themeID);
		dispatchCompleteSuccess(new CommandResult(themesID));
	}
}
}