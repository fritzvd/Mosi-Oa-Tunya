package;

import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

class Oar extends Entity {

  public var sprite:Image;

  public function new (x, y) {
    super(x, y);
    sprite = Image.createRect(25, 3, 0x5e2f0f);
    graphic = sprite;
  }

  public override function update() {
    super.update();
  }
}
