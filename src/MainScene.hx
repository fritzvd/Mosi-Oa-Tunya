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
import Oar;

import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;

class MainScene extends Scene
{
	private var kagiso:Character;
	private var WATERFALL_SPEED:Float;
	private var ec:EmitController;
	private var mountain:Mountain;
	// private var space:Space;
	private var world:B2World;
	private var perlin:Perlin;

	private var rightOar:Oar;
	private var leftOar:Oar;

	public var physScale:Int;

	public override function begin()
	{
		physScale = 1;
		// WATERFALL_SPEED = 0.3;
		kagiso = add(new Character(300, 0));
		ec = add(new EmitController());
		mountain = add(new Mountain(10,10));

		rightOar = add(new Oar(kagiso.endOfRightOar.x, kagiso.endOfRightOar.y));
		rightOar.sprite.angle = kagiso.sprite.angle;
		leftOar = add(new Oar(kagiso.endOfLeftOar.x, kagiso.endOfLeftOar.y));
		leftOar.sprite.angle = kagiso.sprite.angle;

		perlin = new Perlin();
		setupPhysics();
	}

	private function setupPhysics () {
		var gravity:B2Vec2 = new B2Vec2(0, 5);
		world = new B2World(gravity, true);

		var floor:B2PolygonShape= new B2PolygonShape();
		var floorBody:B2BodyDef = new B2BodyDef();
		floorBody.position.set(0, (HXP.height + 20) / physScale);

		floor.setAsBox(HXP.width / physScale, 10 / physScale);
		var floorB:B2Body = world.createBody(floorBody);
		floorB.createFixture2(floor);

		kagiso.boat = world.createBody(kagiso.boatDef);
		kagiso.boat.createFixture(kagiso.boatFixture);

				for (i in 0...10) {
					var debrisx:Float = Math.random() * HXP.width;
					var debrisy:Float = Math.random() * HXP.height;
					var lily = add(new Debris(debrisx, debrisy));
					lily.setGraphic('graphics/lily.png');
					lily.setGravity(5);
					lily.body = world.createBody(lily.bodyDef);
					lily.body.createFixture(lily.bodyFixture);
				}
	}

	public override function update () {

		world.step(HXP.elapsed, 10, 10);
		world.clearForces();

		if (Inputs.action() == 'right') {
			var angle = kagiso.row(false);
			ec.splash(kagiso.endOfRightOar.x + 20 * Math.cos(angle),
				kagiso.endOfRightOar.y + 20 * Math.sin(angle));
		}
		if (Inputs.action() == 'left') {
			kagiso.row(true);
			ec.splash(kagiso.endOfLeftOar.x, kagiso.endOfLeftOar.y);
		}

		if (Inputs.holding() == 'right') {
			var angle = kagiso.holdOar(false);
			ec.splash(kagiso.endOfRightOar.x + 20 * Math.cos(angle),
				kagiso.endOfRightOar.y + 20 * Math.sin(angle));
		}
		if (Inputs.holding() == 'left') {
			kagiso.holdOar(true);
			ec.splash(kagiso.endOfLeftOar.x, kagiso.endOfLeftOar.y);
		}

		if (kagiso.collideWith(mountain, mountain.x, mountain.y) != null) {
			// trace('wiehaa');
		}

		rightOar.x = kagiso.endOfRightOar.x;
		rightOar.y = kagiso.endOfRightOar.y;
		rightOar.sprite.angle = kagiso.sprite.angle - 90;
		leftOar.x = kagiso.endOfLeftOar.x;
		leftOar.y = kagiso.endOfLeftOar.y;
		leftOar.sprite.angle = kagiso.sprite.angle - 90;

		camera.y = kagiso.y - HXP.height / 2;

		if (Input.check(Key.ESCAPE)) {
			#if !html5
			openfl.system.System.exit();
			#end
		}

		super.update();

	}
}
