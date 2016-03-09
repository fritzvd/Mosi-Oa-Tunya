package;

import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

import nape.geom.Vec2;
import nape.shape.Polygon;
import nape.phys.Body;

class Debris extends Entity {

  private var sprite:Image;
  public var body:Body;
  public function new (x, y) {
    super(x, y);
    layer = 2;

    body = new Body();
    body.shapes.add(new Polygon(Polygon.box(20, 20)));
    body.gravMass = 0.1;
    body.position.setxy(this.x, this.y);
  }

  public function setGravity (grav:Float) {
    body.gravMass = grav;
  }

  public function setGraphic(fileName) {
    sprite = new Image(fileName);
    sprite.smooth = false;
    sprite.scale = 4;

    graphic = sprite;
  }

  public override function update() {
    super.update();

    this.x = body.position.x;
    this.y = body.position.y;

    if (this.y > HXP.height) {
      body.position.y = -20;
    }
  }
}
