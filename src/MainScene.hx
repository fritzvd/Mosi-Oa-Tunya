import com.haxepunk.Scene;
import Inputs;

import Character;
import EmitController;
import Mountain;

class MainScene extends Scene
{
	private var kagiso:Character;
	private var WATERFALL_SPEED:Float;
	private var ec:EmitController;
	private var mountain:Mountain;

	public override function begin()
	{
		WATERFALL_SPEED = 0.3;
		kagiso = new Character(500, 200);
		add(kagiso);
		ec = add(new EmitController());
		mountain = add(new Mountain(10,10));
	}

	public override function update () {
		super.update();

		if (Inputs.action() == 'right') {
			kagiso.goRight();
			// ec.splash(kagiso.x, kagiso.y);
		}
		if (Inputs.action() == 'left') {
			kagiso.goLeft();
			// ec.splash(kagiso.x, kagiso.y);
		}

		kagiso.y += WATERFALL_SPEED;

	}
}
