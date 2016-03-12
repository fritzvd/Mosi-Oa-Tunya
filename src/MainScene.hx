package;

import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;
import com.haxepunk.Sfx;

import noisehx.Perlin;

import Inputs;
import entities.Character;
import entities.EmitController;
import entities.Waterfall;
import entities.Mountain;
import entities.GameMap;
import entities.Debris;
import entities.Oar;
import entities.HealthBox;

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
	private var gamemap:GameMap;
	private var healthBox:HealthBox;

	private var _action:String;
	private var _holding:String;
	private var _shooting:Bool;
	private var _restart:Bool;

	private var waterfalls:Array<Waterfall>;

	public var physScale:Int;

	private var splash:Sfx = new Sfx('audio/splash.ogg');
	private var waterfall:Sfx = new Sfx('audio/waterfall.ogg');
	private var collision:Sfx = new Sfx('audio/collision.ogg');
	private var swamp:Sfx = new Sfx('audio/swamp.ogg');
	private var hurrah:Sfx = new Sfx('audio/hurrah.ogg');


	public override function begin() {
		physScale = 5;


		gamemap = add(new GameMap());

		ec = add(new EmitController());
		mountain = add(new Mountain(Std.int(Math.random() * HXP.width), -2000));

		neo = add(new Character(300, 0));
		rightOar = add(new Oar(neo.endOfRightOar.x, neo.endOfRightOar.y));
		rightOar.sprite.angle = neo.sprite.angle;
		leftOar = add(new Oar(neo.endOfLeftOar.x, neo.endOfLeftOar.y));
		leftOar.sprite.angle = neo.sprite.angle;

		healthBox = add(new HealthBox(Std.int(HXP.width * 0.5), 30));

		waterfalls = [];
		var amount = Std.int(HXP.width * gamemap.timesX / 20 * 4);
		var waterfallStartX = -HXP.halfWidth * gamemap.timesX;
		for (i in 0...amount) {
			waterfalls.push(add(new Waterfall(waterfallStartX + i * 20 * 4, HXP.height - 80)));
		}

		perlin = new Perlin();
		setupPhysics();
	}

	private function setupPhysics () {
		var gravity:B2Vec2 = new B2Vec2(0, 5);
		world = new B2World(gravity, true);

		var floor:B2PolygonShape= new B2PolygonShape();
		var floorBody:B2BodyDef = new B2BodyDef();
		floorBody.position.set(0, (HXP.height + 50) / physScale);

		floor.setAsBox(HXP.width / physScale, 10 / physScale);
		var floorB:B2Body = world.createBody(floorBody);
		floorB.createFixture2(floor);

		neo.boat = world.createBody(neo.boatDef);
		neo.boat.createFixture(neo.boatFixture);

		var typesOfDebris = [
			{
				gravity: 30,
				graphic: 'lily.png',
				scale: 4
			},
			{
				gravity: 100,
				graphic: 'wood.png',
				scale: 2
			}
		];

		for (i in 0...50) {
			var debrisx:Float = Math.random() * HXP.width * gamemap.timesX;
			var debrisy:Float = Math.random() * HXP.height * gamemap.timesY;
			var debris = add(new Debris(debrisx, debrisy));
			var debrisType = typesOfDebris[Std.random(2)];
			debris.setGraphic('graphics/' + debrisType.graphic, debrisType.scale);
			debris.setGravity(debrisType.gravity * Math.random());
			debris.body = world.createBody(debris.bodyDef);
			debris.body.createFixture(debris.bodyFixture);
		}
	}

	private function handleTouch(touch:Touch) {
    if (touch.x > 0 && touch.x < HXP.halfWidth) {
			if (touch.pressed) {
				_action = 'right';
			}
			_holding = 'right';
    } else {
			if (touch.pressed) {
			_action = 'left';
		}
			_holding = 'left';
    }
		_restart = true;
	}

	public override function update () {

		if (!finished || !neo.dead) {
			world.step(HXP.elapsed, 10, 10);
			world.clearForces();
		}

		if (finished || neo.dead) {
			var graphic:String = null;
			if (neo.dead) {
				graphic = 'dead';
			} else {
				graphic = 'finished';
				if (!hurrah.playing) {
					hurrah.play();
				}
			}
			var deadoralive = addGraphic(new Image('graphics/' + graphic + '.png'));
			deadoralive.x = camera.x;
			deadoralive.y = camera.y;
		}

		#if !mobile
		_action = Inputs.action();
		_holding = Inputs.holding();
		_shooting = Inputs.shooting();
		_restart = Inputs.restart();
		#end

		#if mobile
		Input.touchPoints(handleTouch);
		#end

		if (_action == 'right') {
			var angle = neo.row(false);
			#if !html5
			ec.splash(neo.endOfRightOar.x + 20 * Math.cos(angle),
				neo.endOfRightOar.y + 20 * Math.sin(angle));
			#end
		}
		if (_action == 'left') {
			neo.row(true);
			#if !html5
			ec.splash(neo.endOfLeftOar.x, neo.endOfLeftOar.y);
			#end
		}

		if (_holding == 'right') {
			var angle = neo.holdOar(false);
			#if !html5
			ec.smallSplash(neo.endOfRightOar.x + 20 * Math.cos(angle),
				neo.endOfRightOar.y + 20 * Math.sin(angle));
			#end
			rightOar.row();
			if (!splash.playing) {
				splash.play();
			}
		}
		if (_holding == 'left') {
			neo.holdOar(true);
			#if !html5
			ec.smallSplash(neo.endOfLeftOar.x, neo.endOfLeftOar.y);
			#end
			leftOar.row();
			if (!splash.playing) {
				splash.play();
			}
		}

		if (neo.collideWith(mountain, neo.x, neo.y) != null) {
			finished = true;
		}

		if (neo.collide('waterfall', neo.x, neo.y) != null || neo.health <= 0.2) {
			neo.die();
			neo.health = 0;
		}

		if (neo.collide('solid', neo.x, neo.y) != null) {
			neo.slowDown();
			neo.health -= 0.1;
			if (!swamp.playing) {
				swamp.play();
			}
		}

		if (neo.collide('debris', neo.x, neo.y) != null) {
			neo.health -= 0.1;
			if (!collision.playing) {
				collision.play();
			}
		}

		_action = '';
		_holding = '';

		rightOar.x = neo.endOfRightOar.x;
		rightOar.y = neo.endOfRightOar.y;
		rightOar.sprite.angle = neo.sprite.angle - 90;
		leftOar.x = neo.endOfLeftOar.x;
		leftOar.y = neo.endOfLeftOar.y;
		leftOar.sprite.angle = neo.sprite.angle - 90;

		if (neo.y < HXP.halfHeight &&
				neo.y > 0 - HXP.halfHeight * gamemap.timesY) {
			camera.y = neo.y - HXP.halfHeight;
		}

		if (neo.x > 0 - HXP.halfWidth / gamemap.timesX &&
				neo.x < HXP.halfWidth * gamemap.timesX) {
			camera.x = neo.x - HXP.halfWidth;
		}

		healthBox.updateHealth(Std.int(neo.health));

		if (Input.check(Key.ESCAPE)) {
			#if !html5
			openfl.system.System.exit(1);
			#end
		}

		if (_restart && (finished || neo.dead)) {
			HXP.scene = new MainScene();
		}

		super.update();
	}
}
