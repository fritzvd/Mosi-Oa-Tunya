package;

import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

import noisehx.Perlin;

import Inputs;
import entities.Character;
import entities.EmitController;
import entities.Waterfall;
import entities.Mountain;
import entities.Debris;
import entities.Oar;

import box2D.dynamics.B2World;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;

class MainScene extends Scene
{
	private var neo:Character;
	private var WATERFALL_SPEED:Float;
	private var ec:EmitController;
	private var mountain:Mountain;
	// private var space:Space;
	private var world:B2World;
	private var perlin:Perlin;
	private var rightOar:Oar;
	private var leftOar:Oar;
	private var finished:Bool;

	private var waterfalls:Array<Waterfall>;

	public var physScale:Int;


	public override function begin() {
		physScale = 1;

		neo = add(new Character(300, 0));
		ec = add(new EmitController());
		mountain = add(new Mountain(Std.int(Math.random() * HXP.width), -2000));
		rightOar = add(new Oar(neo.endOfRightOar.x, neo.endOfRightOar.y));
		rightOar.sprite.angle = neo.sprite.angle;
		leftOar = add(new Oar(neo.endOfLeftOar.x, neo.endOfLeftOar.y));
		leftOar.sprite.angle = neo.sprite.angle;

		waterfalls = [];
		var amount = Std.int(HXP.width / 20 * 4);
		for (i in 0...amount) {
			waterfalls.push(add(new Waterfall(i * 20 * 4, HXP.height - 80)));
		}

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

		neo.boat = world.createBody(neo.boatDef);
		neo.boat.createFixture(neo.boatFixture);

				for (i in 0...10) {
					var debrisx:Float = Math.random() * HXP.width;
					var debrisy:Float = Math.random() * HXP.height;
					var lily = add(new Debris(debrisx, debrisy));
					lily.setGraphic('graphics/lily.png');
					lily.setGravity(Math.random() * 50);
					lily.body = world.createBody(lily.bodyDef);
					lily.body.createFixture(lily.bodyFixture);
				}
	}

	public override function update () {

		if (!finished) {
			world.step(HXP.elapsed, 10, 10);
			world.clearForces();
		}

		if (Inputs.action() == 'right') {
			var angle = neo.row(false);
			ec.splash(neo.endOfRightOar.x + 20 * Math.cos(angle),
				neo.endOfRightOar.y + 20 * Math.sin(angle));
		}
		if (Inputs.action() == 'left') {
			neo.row(true);
			ec.splash(neo.endOfLeftOar.x, neo.endOfLeftOar.y);
		}

		if (Inputs.holding() == 'right') {
			var angle = neo.holdOar(false);
			ec.smallSplash(neo.endOfRightOar.x + 20 * Math.cos(angle),
				neo.endOfRightOar.y + 20 * Math.sin(angle));
			rightOar.row();
		}
		if (Inputs.holding() == 'left') {
			neo.holdOar(true);
			ec.smallSplash(neo.endOfLeftOar.x, neo.endOfLeftOar.y);
			rightOar.row();
		}

		if (neo.collideWith(mountain, neo.x, neo.y) != null) {
			finished = true;
			trace('you made it', mountain.x, mountain.y, neo.collideWith(mountain, mountain.x, mountain.y));
		}

		if (neo.collide('waterfall', neo.x, neo.y) != null) {
			neo.die();
		}

		rightOar.x = neo.endOfRightOar.x;
		rightOar.y = neo.endOfRightOar.y;
		rightOar.sprite.angle = neo.sprite.angle - 90;
		leftOar.x = neo.endOfLeftOar.x;
		leftOar.y = neo.endOfLeftOar.y;
		leftOar.sprite.angle = neo.sprite.angle - 90;

		if (neo.y < HXP.halfHeight) {
			camera.y = neo.y - HXP.height / 2;
		} else {
			camera.y = 0;
		}

		if (Input.check(Key.ESCAPE)) {
			#if !html5
			openfl.system.System.exit(1);
			#end
		}

		super.update();
	}
}
