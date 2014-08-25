package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.common.DataBaseInfo;

import flash.data.SQLResult;

public class TransUnitWithAudioCountTransactionPhase extends PhaseOperation {

	public function TransUnitWithAudioCountTransactionPhase(sqlRunner:SQLRunner, info:DataBaseInfo, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.info = info;
		this.sqlFactory = sqlFactory;
	}

	private var info:DataBaseInfo;
	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		sqlRunner.execute(sqlFactory.selectCountTransUnitWithAudio, null, executeComplete);
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				info.audioRecordsAmount = countData[prop] as int;
				break;
			}
			dispatchComplete();
		}
		else {
			throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число фраз с аудиозаписями в таблице");
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		sqlRunner = null;
	}
}
}
