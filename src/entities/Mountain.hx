package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Mountain extends Entity {

  private var image:Image;

  public function new (x:Int, y:Int) {
    super(x, y);

    name = 'mountain';
    layer = 10;
    image = new Image('graphics/mountain.png');
    image.scale = 5;
    setHitbox(Std.int(image.scaledWidth), Std.int(image.scaledHeight));

    graphic = image;
    image.smooth = false;
  }

}
