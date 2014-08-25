package dittner.testmyself.command.backend {
import dittner.testmyself.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.model.common.TransUnit;

public class TransUnitValidationPhase extends PhaseOperation {
	public function TransUnitValidationPhase(unit:TransUnit) {
		this.unit = unit;
	}

	private var unit:TransUnit;

	override public function execute():void {
		if (!unit)
			throw new CommandException(ErrorCode.NULL_TRANS_UNIT, "Отсутствует единица перевода");
		else if (unit.origin && unit.translation)
			dispatchComplete();
		else
			throw new CommandException(ErrorCode.FORM_NOT_FILLED, "Форма не заполнена: исходный текст и перевод не должны быть пустыми");
	}

	override public function destroy():void {
		super.destroy();
		unit = null;
	}
}
}
