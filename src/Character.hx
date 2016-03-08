package;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.tweens.misc.AngleTween;
import com.haxepunk.utils.Ease;
import com.haxepunk.Tween.TweenType;

class Character extends Entity {
  public var sprite:Image;

  private var motion:LinearMotion;
  private var moveDirection:String;
  private var angleMove:AngleTween;
  private var boatAngle:Float;
  private var rowRadius:Int;
  private var boatSpeed:Float;
  private var turnSpeed:Float;

  private var velX:Float;
  private var velY:Float;

  public function new (x,  y) {
    super(x, y);

    sprite = new Image('graphics/boat.png');
    sprite.scale = 4.0;
    sprite.smooth = false;
    sprite.centerOrigin();
    graphic = sprite;

    motion = new LinearMotion(clearMotion);
    this.addTween(motion);

    boatAngle = Math.PI / 2;

    velX = 0;
    velY = 0;

    rowRadius = 5;
    boatSpeed = 0.5;
    turnSpeed = 0.1;
    name = 'kagiso';
    setHitbox(Std.int(sprite.scaledWidth), Std.int(sprite.scaledHeight));
  }

  private function clearMotion (_) {
    moveDirection = '';
  }

  public function goLeft() {
    var p = calculateVector(x, y, rowRadius, boatAngle, true);
    motion.setMotion(x, y, p.get('x'), p.get('y'), 0.3);
    motion.start();
    moveDirection = 'left';

    // velX -= boatSpeed * Math.cos(boatAngle);
    // velY -= boatSpeed * Math.sin(boatAngle);
    boatAngle = boatAngle + turnSpeed;
  }

  public function goRight() {
    var p = calculateVector(x, y, rowRadius, boatAngle);
    motion.setMotion(x, y, p.get('x'), p.get('y'), 0.3);
    motion.start();
    moveDirection = 'right';

    // velX += boatSpeed * Math.cos(boatAngle);
    // velY += boatSpeed * Math.sin(boatAngle);
    boatAngle = boatAngle - turnSpeed;
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
  private function calculateVector (originX:Float, originY:Float, radius, startAngle:Float, ?left:Bool=false) {
   var newLocation = new Map<String, Float>();

   var angle:Float = HXP.RAD * startAngle + 6.283185307 / 10; // move along a tenth of the circle
   var direction = (left) ? -1 : 1;

   var newx = originX + radius * Math.sin(angle);
   var newy = originY - radius * (direction - Math.cos(angle));

   trace(newx, newy, angle, x,y );

   newLocation.set('x', newx);
   newLocation.set('y', newy);
   newLocation.set('angle', angle);
   return newLocation;
 }

  public override function update () {
    sprite.angle = 180 - boatAngle * HXP.DEG;

    if (motion.active) {
      // velX += (x - motion.x) * boatSpeed;
      // velX += (y - motion.y) * boatSpeed;
      x = motion.x;
      y = motion.x;
    }

    if (motion.active && moveDirection == 'right') {
      // velX -= (x - motion.x) * boatSpeed;
      // velX -= (y - motion.y) * boatSpeed;
    }

    velX *= 0.97; // slow down x and y
    velY *= 0.97;

    x += velX;
    y += velY;

    super.update();
  }
}
