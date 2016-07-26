package de.dittner.testmyself.model.settings {
import de.dittner.walter.WalterProxy;

public class SettingsModel extends WalterProxy {



	override protected function deactivate():void {
		so.close();
	}

}
}