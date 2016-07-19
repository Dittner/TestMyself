package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.backend.SQLStorage;

public class UpdateTestTaskCmd implements ISFCommand {

	[Inject]
	public var service:SQLStorage;

	public function execute(msg:IRequestMessage):void {
		service.updateTestTask(msg);
	}
}
}
