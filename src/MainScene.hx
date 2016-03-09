import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import noisehx.Perlin;

import Inputs;
import Character;
import EmitController;
import Mountain;
import Debris;

import nape.space.Space;
import nape.geom.Vec2;
import nape.shape.Polygon;
import nape.phys.Body;
import nape.phys.BodyType;

class MainScene extends Scene
{
	private var kagiso:Character;
	private var WATERFALL_SPEED:Float;
	private var ec:EmitController;
	private var mountain:Mountain;
	private var space:Space;
	private var perlin:Perlin;

	public override function begin()
	{

		// WATERFALL_SPEED = 0.3;
		kagiso = add(new Character(300, 0));
		ec = add(new EmitController());
		mountain = add(new Mountain(10,10));

		perlin = new Perlin();
		setupPhysics();
	}

	private function setupPhysics () {
		var gravity:Vec2 = new Vec2(0, 10);
		space = new Space(gravity);

		var floorBody:Body = new Body(BodyType.STATIC);
		var floorShape:Polygon = new Polygon(Polygon.rect(0, HXP.height + 15, HXP.width, 1));
		floorBody.shapes.add(floorShape);
		space.compounds.add(kagiso.boat);
		space.bodies.add(floorBody);

				for (i in 0...10) {
					var debrisx:Float = Math.random() * HXP.width;
					var debrisy:Float = Math.random() * HXP.height;
					trace(debrisx, debrisy);
					var lily = add(new Debris(debrisx, debrisy));
					lily.setGraphic('graphics/lily.png');
					lily.setGravity(Math.random() * 0.5);
					space.bodies.add(lily.body);
				}
	}

	public override function update () {
		super.update();
		space.step(HXP.elapsed);

		if (Inputs.action() == 'right') {
			kagiso.row(false);
			ec.splash(kagiso.x, kagiso.y);
		}
		if (Inputs.action() == 'left') {
			kagiso.row(true);
			ec.splash(kagiso.x, kagiso.y);
		}

		if (kagiso.collideWith(mountain, mountain.x, mountain.y) != null) {
			// trace('wiehaa');
		}

		if (Input.check(Key.ESCAPE)) {
			#if !html5
			openfl.system.System.exit();
			#end
		}
		// kagiso.y = boatBody.position.y;
		// kagiso.y += WATERFALL_SPEED;

	}
}
