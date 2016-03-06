
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

    boatAngle = Math.PI / 2;

    velX = 0;
    velY = 0;

    rowRadius = 5;
    boatSpeed = 0.5;
    turnSpeed = 0.1;

  }

  public function goLeft() {
    velX -= boatSpeed * Math.cos(boatAngle);
    velY -= boatSpeed * Math.sin(boatAngle);
    boatAngle = boatAngle + turnSpeed;
  }

  public function goRight() {
    velX += boatSpeed * Math.cos(boatAngle);
    velY += boatSpeed * Math.sin(boatAngle);
    boatAngle = boatAngle - turnSpeed;
  }


  public override function update () {
    sprite.angle = 180 - boatAngle * HXP.DEG;

    velX *= 0.97; // slow down x and y
    velY *= 0.97;

    x += velX;
    y += velY;

    super.update();
  }
}
