package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.SQLLib;
import de.dittner.testmyself.model.domain.theme.Theme;

import flash.data.SQLConnection;

public class InsertThemeOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function InsertThemeOperationPhase(conn:SQLConnection, note:Note) {
		this.conn = conn;
		this.themes = note.themes;
		this.sqlFactory = sqlFactory;
	}

	private var themes:Array;
	private var conn:SQLConnection;
	private var sqlFactory:SQLLib;

	public function execute():void {
		var addedThemes:Vector.<Theme> = getAddedThemes();
		if (addedThemes.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var theme:Theme in addedThemes)
				composite.addOperation(InsertThemeOperationSubPhase, theme, conn, SQLLib.INSERT_THEME_SQL);

			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function getAddedThemes():Vector.<Theme> {
		var res:Vector.<Theme> = new <Theme>[];

		for each(var theme:Theme in themes)
			if (theme.isNew) res.push(theme);

		return res;
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) {
			dispatchSuccess(op.result);
		}
		else {
			CLog.err(LogCategory.STORAGE, op.error);
			dispatchError(op.error);
		}
	}

	override public function destroy():void {
		super.destroy();
		themes = null;
		conn = null;
	}
}
}