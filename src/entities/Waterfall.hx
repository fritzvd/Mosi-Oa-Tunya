package entities;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.tweens.misc.VarTween;

class Waterfall extends Entity {

  public var sprite:Spritemap;
  private var tween:VarTween;

  public function new (x, y) {
    super(x, y);
    sprite = new Spritemap('graphics/waterfall.png', 20, 10);
    sprite.smooth = false;
    sprite.scale = 4;
    sprite.add('idle', [0, 1, 2, 3], 12);
    sprite.play('idle');

    this.type = 'waterfall';
    this.width = Std.int(sprite.scaledWidth);
    this.height = Std.int(sprite.scaledHeight);
    setHitbox(width, height);

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
