
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.tweens.misc.AngleTween;
import com.haxepunk.utils.Ease;
import com.haxepunk.Tween.TweenType;

class Character extends Entity {
  public var sprite:Image;

  // private var motion:BoatMotion;
  private var motion:LinearMotion;
  private var angleMove:AngleTween;
  private var boatAngle:Float;
  private var rowRadius:Int;
  private var boatSpeed:Int;

  private var velX:Float;
  private var velY:Float;

  public function new (x,  y) {
    super(x, y);

    sprite = new Image('graphics/boat.png');
    sprite.scale = 3.0;
    sprite.smooth = false;
    sprite.centerOrigin();
    graphic = sprite;

    boatAngle = 0;

    velX = 0;
    velY = 0;

    rowRadius = 5;
    boatSpeed = 10;

    setupTweens();
  }

  public function setupTweens () {
    motion = new LinearMotion();
    angleMove = new AngleTween(TweenType.Persist);

    this.addTween(motion);
    this.addTween(angleMove);
  }

  private function tweenDone(_):Void {
    // done;
    return;
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
   private function calculateCenterOfMotion (originX:Float, originY:Float, radius, startAngle:Float, ?left:Bool=false) {
    var centerOfMotion = new Map<String, Int>();
    var direction = 1;
    var angle = HXP.RAD * startAngle + 6.283185307 / 10;
    var x = originX + radius * Math.sin(angle);
    if (left) {
      direction = -1;
    }
    var y = originY - radius * (direction - Math.cos(angle));

    centerOfMotion.set('x', Std.int(x));
    centerOfMotion.set('y', Std.int(y));
    return centerOfMotion;
  }

  private function calculateNextPoint(originX:Float, originY:Float, angle:Float, speed:Int) {
    var newLocation = new Map<String, Int>();

    var dX = speed * Math.cos(angle * HXP.RAD);
    var dY = speed * Math.cos(angle * HXP.RAD);
    trace(dX, dY);
    newLocation.set('x', Std.int(x - dX));
    newLocation.set('y', Std.int(y - dY));
    return newLocation;
  }

  public function goRight () {
    angleMove.tween(boatAngle, boatAngle - 45.0, 0.3);
    angleMove.start();
    // var c = calculateCenterOfMotion(x, y, rowRadius, boatAngle);
    // motion.setMotion(c.get('x'), c.get('y'), rowRadius, boatAngle, true, 0.3, Ease.circIn);
    var p = calculateNextPoint(x, y, boatAngle + 45, boatSpeed);
    motion.setMotion(x, y, p.get('x'), p.get('y'), 0.3);
    motion.start();
  }

  public function goLeft () {
    angleMove.tween(boatAngle, boatAngle + 45.0, 0.3);
    angleMove.start();
    var p = calculateNextPoint(x, y, boatAngle - 45, boatSpeed);
    motion.setMotion(x, y, p.get('x'), p.get('y'), 0.3);

    // var c = calculateCenterOfMotion(x, y, rowRadius, boatAngle, true);
    // motion.setMotion(c.get('x'), c.get('y'), rowRadius, boatAngle, false, 0.3, Ease.circIn);
    motion.start();
  }

  public function updateAngle(angle) {
    sprite.angle += angle;

  }

  public override function update () {
    sprite.angle = boatAngle;

    if (angleMove.active) {
      boatAngle = angleMove.angle;
    }

    if (motion.active) {
      trace(this.x, motion.x);
      this.x = motion.x;
      this.y = motion.y;
    }
    super.update();
  }
}
