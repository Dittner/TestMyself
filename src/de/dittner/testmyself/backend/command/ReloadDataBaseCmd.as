package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.backend.SQLStorage;

public class ReloadDataBaseCmd implements ISFCommand {

	[Inject]
	public var service:SQLStorage;

	public function execute(msg:IRequestMessage):void {
		service.reloadDataBase(msg);
	}
}
}
