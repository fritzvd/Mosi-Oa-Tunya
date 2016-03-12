package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;

import box2D.dynamics.*;
import box2D.common.math.B2Vec2;
import box2D.collision.shapes.*;

class Character extends Entity {
  public var sprite:Image;
  public var boatDef:B2BodyDef;
  public var boat:B2Body;
  public var boatShape:B2PolygonShape;
  public var boatFixture:B2FixtureDef;

  public var endOfRightOar:B2Vec2;
  public var endOfLeftOar:B2Vec2;

  public var dead:Bool;

  private var boatAngle:Float;
  private var boatSpeed:Float;
  private var turnSpeed:Float;
  private var rowRadius:Float;
  private var moveDirection:String;
  private var physScale:Int;
  public var health:Float;

  public function new (x,  y) {
    super(x, y);

    sprite = new Image('graphics/boat.png');
    sprite.scale = 4.0;
    sprite.smooth = false;
    sprite.centerOrigin();
    graphic = sprite;

    dead = false;

    turnSpeed = 0.1;
    boatSpeed = 0.9;
    boatAngle = Math.PI / 2 * Math.random();
    rowRadius = 0.1;

    name = 'kagiso';
    health = 100.0;

    endOfLeftOar = new B2Vec2(x + 60 * Math.cos(boatAngle), y + 60 * Math.sin(boatAngle));
    endOfRightOar = new B2Vec2(x - 60 * Math.cos(boatAngle), y - 60 * Math.sin(boatAngle));

    var scene:MainScene = cast(HXP.scene, MainScene);
    physScale = scene.physScale;
    setupPhysics();

    setHitbox(Std.int(sprite.scaledWidth), Std.int(sprite.scaledHeight));
  }

  private function setupPhysics() {
    var boatShape:B2PolygonShape= new B2PolygonShape();
		boatDef = new B2BodyDef();
    boatDef.type = 2; // dynamic

    boatDef.position.set(Std.int(x) / physScale, Std.int(y) / physScale);
		boatShape.setAsBox(sprite.scaledHeight / physScale, sprite.scaledWidth / physScale / 2);
    boatFixture = new B2FixtureDef ();

    boatFixture.shape = boatShape;
    setHitbox(Std.int(sprite.scaledWidth), Std.int(sprite.scaledHeight));
  }

  public function row(?left:Bool) {
    var v = calculateArc(left);

    var direction = (left) ? -1 : 1;
    var c = 200;
    var force:B2Vec2 = new B2Vec2(v.get('x') * c, v.get('y') * c);

    this.boat.applyForce(force, new B2Vec2(
      direction * Math.cos(boatAngle),
      direction * Math.sin(boatAngle))
    );

    return boatAngle;
  }

  public function die () {
    dead = true;
  }

  public function holdOar(?left:Bool) {
    var angle = calculateNewAngle(boatAngle);
    var direction = (left) ? -1 : 1;
    var c = 500;

    this.boat.applyTorque(c * direction * Math.abs(boatAngle - angle));
    this.boat.setAngularDamping(50);
    slowDown();

    return boatAngle;
  }

  public function slowDown () {
    this.boat.setLinearDamping(1);
  }

  private function calculateArc (?left:Bool) {
    var velocity = new Map<String, Float>();
    var velX:Float = 0;
    var velY:Float = 0;

    if (left) {
      velX -= boatSpeed * Math.cos(boatAngle - Math.PI / 2);
      velY -= boatSpeed * Math.sin(boatAngle - Math.PI / 2);
      boatAngle = boatAngle - turnSpeed;

    } else {
      velX += boatSpeed * Math.cos(boatAngle + Math.PI / 2);
      velY += boatSpeed * Math.sin(boatAngle + Math.PI / 2);
      boatAngle = boatAngle + turnSpeed;

    }
    velocity.set('x', velX);
    velocity.set('y', velY);
    return velocity;
  }

  private function calculateNewAngle (startAngle:Float) {
    var angle:Float = HXP.RAD * startAngle + 6.283185307 / 12; // move along a tenth of the circle
    return angle;
  }

  // Calculate the new xy of the Oars
  // and place them in the right position.
  private function placeOars () {
    endOfRightOar.x = this.x + 20 * Math.cos(boatAngle);
    endOfRightOar.y = this.y + 20 * Math.sin(boatAngle);
    endOfLeftOar.x = this.x - 40 * Math.cos(boatAngle);
    endOfLeftOar.y = this.y - 40 * Math.sin(boatAngle);
  }

  public override function update () {
    var pos:B2Vec2 = boat.getPosition();
    if (!dead) {
      sprite.angle = 90 + boatAngle * HXP.DEG;
    }

    this.x = pos.x * physScale;
    this.y = pos.y * physScale;

    placeOars();

    if (dead) {
      sprite.scale -= 0.1;
      sprite.angle -= 1;
    }

    super.update();
  }
}
