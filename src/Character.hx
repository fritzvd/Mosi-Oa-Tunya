package;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Graphiclist;

import nape.phys.Body;
import nape.phys.Compound;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.space.Space;
import nape.constraint.WeldJoint;

class Character extends Entity {
  public var sprite:Image;
  public var leftOar:Body;
  public var rightOar:Body;
  public var boat:Compound;

  private var boatConstraint:WeldJoint;
  private var leftOarBox:Image;
  private var graphicList:Graphiclist;
  private var rightOarBox:Image;
  private var boatAngle:Float;
  private var boatSpeed:Float;
  private var turnSpeed:Float;
  private var rowRadius:Float;
  private var moveDirection:String;

  public function new (x,  y) {
    super(x, y);

    sprite = new Image('graphics/boat.png');
    sprite.scale = 4.0;
    sprite.smooth = false;
    sprite.centerOrigin();
    graphic = sprite;

#if debug
    graphicList = new Graphiclist();
    graphic = graphicList;
#end
    turnSpeed = 0.1;
    boatSpeed = 0.9;
    boatAngle = Math.PI / 2;
    rowRadius = 0.1;

    name = 'kagiso';
    layer = 1;

    leftOar = new Body();
    rightOar = new Body();

#if debug
    rightOarBox = Image.createRect(10, 10);
    // rightOarBox.originX = 5;
    // rightOarBox.originY = -10;
    leftOarBox = Image.createRect(10, 10);
    // leftOarBox.originX = 5;
    // leftOarBox.originY = -10;
    graphicList.add(rightOarBox);
    graphicList.add(leftOarBox);
#end

    leftOar.position.setxy(this.x - 15, this.y - 10);
		rightOar.position.setxy(this.x + 15, this.y - 10);
    leftOar.shapes.add(new Polygon(Polygon.box(10, 10)));
		rightOar.shapes.add(new Polygon(Polygon.box(10, 10)));
    var anchor:Vec2 = new Vec2(this.x, this.y + 30);
    var anchor1:Vec2 = leftOar.worldPointToLocal(anchor, true);
    var anchor2:Vec2 = rightOar.worldPointToLocal(anchor, true);
    var phase:Float = rightOar.rotation - leftOar.rotation;
    boatConstraint = new WeldJoint(leftOar, rightOar, anchor1, anchor2, phase);

    boat = new Compound();
    leftOar.compound = boat;
    rightOar.compound = boat;
    boatConstraint.compound = boat;

    setHitbox(Std.int(sprite.scaledWidth), Std.int(sprite.scaledHeight));
  }

  public function row(?left:Bool) {

    var impulse:Vec2 = Vec2.weak();

    var p = calculateVector(x, y, rowRadius, boatAngle, left);
    var v = calculateArc(left);

    impulse.x = v.get('x');
    impulse.y = v.get('y') - 1;

    if (left) {
      this.leftOar.applyImpulse(impulse);
    }
    else {
      this.rightOar.applyImpulse(impulse);
    }
  }

  private function calculateArc (?left:Bool) {
    var velocity = new Map<String, Float>();
    var velX:Float = 0;
    var velY:Float = 0;

    if (left) {
      velX -= boatSpeed * Math.cos(boatAngle);
      velY -= boatSpeed * Math.sin(boatAngle);
      boatAngle = boatAngle - turnSpeed;

    } else {
      velX += boatSpeed * Math.cos(boatAngle);
      velY += boatSpeed * Math.sin(boatAngle);
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
    sprite.angle = leftOar.rotation * HXP.DEG;

    var dx = Math.sqrt(Math.pow(leftOar.position.x, 2) - Math.pow(rightOar.position.x, 2));
    var dy = Math.sqrt(Math.pow(leftOar.position.y, 2) - Math.pow(rightOar.position.y, 2));
    var anchorpoint = leftOar.localPointToWorld(boatConstraint.anchor1);
    x = anchorpoint.x;
    y = anchorpoint.y;

#if debug
    leftOarBox.x = leftOar.position.x;
    leftOarBox.y = leftOar.position.y;
    rightOarBox.y = rightOar.position.y;
    rightOarBox.x = rightOar.position.x;
#end
    super.update();
  }
}
