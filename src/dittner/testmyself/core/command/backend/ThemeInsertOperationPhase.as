package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.CompositeCommand;
import dittner.async.IAsyncCommand;
import dittner.async.IAsyncOperation;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.theme.Theme;

import flash.data.SQLConnection;

public class ThemeInsertOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function ThemeInsertOperationPhase(conn:SQLConnection, themes:Array, sqlFactory:SQLFactory) {
		this.conn = conn;
		this.themes = themes;
		this.sqlFactory = sqlFactory;
	}

	private var themes:Array;
	private var conn:SQLConnection;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		var addedThemes:Vector.<Theme> = getAddedThemes();
		if (addedThemes.length > 0) {
			var composite:CompositeCommand = new CompositeCommand();

			for each(var theme:Theme in addedThemes)
				composite.addOperation(ThemeInsertOperationSubPhase, theme, conn, sqlFactory.insertTheme);

			composite.addCompleteCallback(completeHandler);
			composite.execute();
		}
		else dispatchSuccess();
	}

	private function getAddedThemes():Vector.<Theme> {
		var res:Vector.<Theme> = new <Theme>[];

		for each(var theme:Theme in themes)
			if (isNewTheme(theme)) res.push(theme);

		return res;
	}

	private function isNewTheme(theme:Theme):Boolean {
		return theme.id == -1;
	}

	private function completeHandler(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess(op.result);
		else dispatchError(op.error);
	}

	override public function destroy():void {
		super.destroy();
		themes = null;
		conn = null;
	}
}
}