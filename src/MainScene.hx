import com.haxepunk.Scene;
import Inputs;

import Character;

class MainScene extends Scene
{
	public var kagiso:Character;
	public override function begin()
	{
		kagiso = new Character(500, 200);
		add(kagiso);

	}

	public override function update () {
		super.update();

		if (Inputs.action() == 'right') {
			kagiso.goRight();
		}
		if (Inputs.action() == 'left') {
			kagiso.goLeft();
		}
	}
}
