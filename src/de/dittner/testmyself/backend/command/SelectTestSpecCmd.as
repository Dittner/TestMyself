package de.dittner.testmyself.backend.command {
import de.dittner.satelliteFlight.command.ISFCommand;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.testmyself.model.domain.test.TestModel;
import de.dittner.testmyself.model.domain.test.TestSpec;

public class SelectTestSpecCmd implements ISFCommand {

	[Inject]
	public var testModel:TestModel;

	public function execute(msg:IRequestMessage):void {
		testModel.testSpec = msg.data as TestSpec;
	}

}
}