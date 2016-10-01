package de.dittner.testmyself.ui.view.noteList.components.tag {
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.ui.common.renderer.*;

public class TagRenderer extends StringItemRenderer {

	public function TagRenderer() {
		super();
	}

	override protected function get text():String {
		return data is Tag ? (data as Tag).name : "";
	}
}
}
