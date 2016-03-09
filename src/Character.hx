package;

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

  private var boatAngle:Float;
  private var boatSpeed:Float;
  private var turnSpeed:Float;
  private var rowRadius:Float;
  private var moveDirection:String;
  private var physScale:Int;

  public function new (x,  y) {
    super(x, y);

    sprite = new Image('graphics/boat.png');
    sprite.scale = 4.0;
    sprite.smooth = false;
    sprite.centerOrigin();
    graphic = sprite;

    turnSpeed = 0.1;
    boatSpeed = 0.9;
    boatAngle = Math.PI / 2;
    rowRadius = 0.1;

    name = 'kagiso';
    layer = 1;

    endOfLeftOar = new B2Vec2(x + 60 * Math.cos(boatAngle), y + 60 * Math.sin(boatAngle));
    endOfRightOar = new B2Vec2(x - 60 * Math.cos(boatAngle), y - 60 * Math.sin(boatAngle));

    var scene:MainScene = cast(HXP.scene, MainScene);
    physScale = scene.physScale;

    var boatShape:B2PolygonShape= new B2PolygonShape();
		boatDef = new B2BodyDef();
    boatDef.type = 2; // dynamic

    boatDef.position.set(Std.int(x) / physScale, Std.int(y) / physScale);
		boatShape.setAsBox(sprite.scaledWidth / physScale, sprite.scaledHeight / physScale / 2);
    boatFixture = new B2FixtureDef ();
    boatFixture.shape = boatShape;

    setHitbox(Std.int(sprite.scaledWidth), Std.int(sprite.scaledHeight));
  }

  public function row(?left:Bool) {

    // var p = calculateVector(x, y, rowRadius, boatAngle, left);
    var v = calculateArc(left);

    var direction = (left) ? -1 : 1;
    var c = 3000;
    var force:B2Vec2 = new B2Vec2(v.get('x') * c, v.get('y') * c);

    this.boat.applyForce(force, new B2Vec2(
      direction * Math.cos(boatAngle),
      direction * Math.sin(boatAngle))
    );

    return boatAngle;
  }

  public function holdOar(?left:Bool) {
    var p = calculateVector(x, y, rowRadius, boatAngle, left);
    var direction = (left) ? -1 : 1;
    var c = 3000;

    this.boat.applyTorque(c * direction * Math.abs(boatAngle - p.get('angle')));

    return boatAngle;
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

  /**
   * a
   * |\
   * | \
   * |  \
   * |---.
   * b    c
   *
   *  cx = ax + r sin a'
   *  cy = ay - r(1 - cos a')
   */
  private function calculateVector (originX:Float, originY:Float, radius:Float, startAngle:Float, ?left:Bool=false) {
    var newLocation = new Map<String, Float>();

    var angle:Float = HXP.RAD * startAngle + 6.283185307 / 12; // move along a tenth of the circle
    var direction = (left) ? -1 : 1;

    var newx = originX + radius * Math.sin(angle);
    var newy = originY - radius * (direction - Math.cos(angle));

    newLocation.set('x', newx);
    newLocation.set('y', newy);
    newLocation.set('angle', angle);

    return newLocation;
  }
  public override function update () {
    var pos:B2Vec2 = boat.getPosition();
    sprite.angle = 90 + boatAngle * HXP.DEG;

    this.x = pos.x * physScale;
    this.y = pos.y * physScale;

    endOfRightOar.x = this.x + 20 * Math.cos(boatAngle);
    endOfRightOar.y = this.y + 20 * Math.sin(boatAngle);
    endOfLeftOar.x = this.x - 40 * Math.cos(boatAngle);
    endOfLeftOar.y = this.y - 40 * Math.sin(boatAngle);
    super.update();
  }
}
