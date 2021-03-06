package entities;

import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Ease;
import com.haxepunk.Entity;

class EmitController extends Entity
{
	private var _emitter:Emitter;

	public function new()
	{
		super(x, y);
    _emitter = new Emitter("graphics/particle.png", 5, 5);
    _emitter.newType("splash", [0]);
    _emitter.setMotion("splash",  		// name
        	0, 				// angle
        	20, 			// distance
        	0.5, 				// duration
        	20, 			// ? angle range
        	-20, 			// ? distance range
        	4, 				// ? Duration range
        	Ease.quadIn	// ? Easing
        	);
    _emitter.setAlpha("splash", 20, 0.1);
    _emitter.setGravity("splash", 5, 1);
    graphic = _emitter;
    layer = 10;
	}

	public function splash(x:Float, y:Float) {
		for (i in 0...10)
		{
			_emitter.emit("splash", x, y);
		}
	}

	public function smallSplash(x:Float, y:Float) {
		for (i in 0...2)
		{
			_emitter.emit("splash", x, y);
		}
	}


}
