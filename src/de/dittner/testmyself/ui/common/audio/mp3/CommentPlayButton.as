package de.dittner.testmyself.ui.common.audio.mp3 {
import de.dittner.testmyself.ui.common.button.SpriteButton;

public class CommentPlayButton extends SpriteButton {
	public function CommentPlayButton() {
		super();
		upStateClass = SoundUpIconClass;
		downStateClass = SoundDownIconClass;
		disabledStateClass = SoundDisabledIconClass;
	}

	[Embed(source='/assets/sound_btn_up.png')]
	private static const SoundUpIconClass:Class;
	[Embed(source='/assets/sound_btn_down.png')]
	private static const SoundDownIconClass:Class;
	[Embed(source='/assets/sound_btn_disabled.png')]
	private static const SoundDisabledIconClass:Class;

}
}
