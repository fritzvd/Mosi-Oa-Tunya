import com.haxepunk.Scene;
import com.haxepunk.HXP;

import Inputs;
import Character;
import EmitController;
import Mountain;

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
	private var boatBody:Body;
	// private var boat:Polygon;

	public override function begin()
	{

		// WATERFALL_SPEED = 0.3;
		kagiso = new Character(200, 200);
		add(kagiso);
		ec = add(new EmitController());
		mountain = add(new Mountain(10,10));

		setupPhysics();
	}

	private function setupPhysics () {
		var gravity:Vec2 = new Vec2(0, 10);
		space = new Space(gravity);

		var boat:Polygon = new Polygon(Polygon.box(kagiso.sprite.width, kagiso.sprite.height));
		boatBody = new Body();
		boatBody.position.setxy(kagiso.x, kagiso.y);
		boatBody.shapes.add(boat);

		var floorBody:Body = new Body(BodyType.STATIC);
		var floorShape:Polygon = new Polygon(Polygon.rect(0, HXP.height, HXP.width, 1));
		floorBody.shapes.add(floorShape);
		space.bodies.add(boatBody);
		space.bodies.add(floorBody);
	}

	public override function update () {
		super.update();
		space.step(HXP.elapsed);


		// if (Inputs.action() == 'right') {
		// 	kagiso.goRight();
		// 	ec.splash(kagiso.x, kagiso.y);
		// }
		// if (Inputs.action() == 'left') {
		// 	kagiso.goLeft();
		// 	ec.splash(kagiso.x, kagiso.y);
		// }

		if (kagiso.collideWith(mountain, mountain.x, mountain.y) != null) {
			// trace('wiehaa');
		}

		kagiso.y = boatBody.position.y;
		// kagiso.y += WATERFALL_SPEED;

	}
}
