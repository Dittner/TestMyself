package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLResult;

public class ExampleWithAudioCountOperationPhase extends PhaseOperation {

	public function ExampleWithAudioCountOperationPhase(sqlRunner:SQLRunner, info:NotesInfo, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.info = info;
		this.sqlFactory = sqlFactory;
	}

	private var info:NotesInfo;
	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		sqlRunner.execute(sqlFactory.selectCountExampleWithAudio, null, executeComplete);
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				info.audioCommentsAmount += countData[prop] as int;
				break;
			}
			dispatchComplete();
		}
		else {
			throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число примеров с аудио в таблице");
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		sqlRunner = null;
	}
}
}
