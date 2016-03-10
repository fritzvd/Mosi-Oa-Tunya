package entities;

import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.tweens.misc.VarTween;

class Oar extends Entity {

  public var sprite:Image;
  private var tween:VarTween;

  public function new (x, y) {
    super(x, y);
    sprite = Image.createRect(25, 3, 0x5e2f0f);
    graphic = sprite;

    tween =  new VarTween();
  }

  public function row () {
    tween.tween(sprite, 'scaleX', 0.4, 0.4);
  }

  public override function update() {
    super.update();
  }
}
