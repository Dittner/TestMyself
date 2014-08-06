package dittner.testmyself.service.phrase.operation.add {
import com.probertson.data.SQLRunner;

import dittner.testmyself.model.phrase.PhraseVo;
import dittner.testmyself.model.theme.ThemeVo;
import dittner.testmyself.service.operation.Phase;
import dittner.testmyself.service.operation.PhaseErrorCode;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class AddPhraseThemeTransactionPhase extends Phase {
	public function AddPhraseThemeTransactionPhase(phrase:PhraseVo, sqlRunner:SQLRunner, sqlStatement:String) {
		super();
		this.phrase = phrase;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
	}

	public var phrase:PhraseVo;
	public var sqlRunner:SQLRunner;
	public var sqlStatement:String;

	override protected function validate():Boolean {
		for each(var theme:ThemeVo in phrase.themes) {
			if (isNewTheme(theme)) return true;
		}
		return false;
	}

	private function isNewTheme(theme:ThemeVo):Boolean {
		return theme.id == -1;
	}

	override protected function process():void {
		/*var sqlParams:Object = {};
		 sqlParams["origin"] = phrase.origin;
		 sqlParams["translation"] = phrase.translation;
		 sqlParams["voiceID"] = phrase.voiceID;
		 sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(sqlStatement, sqlParams)]), executeComplete, executeError);

		 */
		completeSuccess();
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		var result:SQLResult = results[0];
		if (result.rowsAffected > 0) {
			phrase.id = result.lastInsertRowID;
			completeSuccess();
		}
		else completeWithError(PhaseErrorCode.NEW_PRASE_ADDED_WITHOUT_ID);
	}

	private function executeError(error:SQLError):void {
		completeWithError(error.toString());
	}
}
}
