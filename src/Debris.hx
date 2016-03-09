package;

import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

import box2D.dynamics.*;
import box2D.common.math.B2Vec2;
import box2D.collision.shapes.*;

class Debris extends Entity {

  private var sprite:Image;
  public var bodyDef:B2BodyDef;
  public var body:B2Body;
  public var bodyShape:B2PolygonShape;
  private var physScale:Int;
  public var bodyFixture:B2FixtureDef;

  public function new (x, y) {
    super(x, y);
    layer = 2;

    var scene:MainScene = cast(HXP.scene, MainScene);
    physScale = scene.physScale;

  }

  public function setGravity (grav:Float) {
    bodyFixture.density = 0.0001;
  }

  public function setGraphic(fileName) {
    sprite = new Image(fileName);
    sprite.smooth = false;
    sprite.scale = 4;

    graphic = sprite;
    setupPhysics();
  }

  private function setupPhysics() {
    var bodyShape:B2PolygonShape= new B2PolygonShape();
    bodyDef = new B2BodyDef();
    bodyDef.type = 2; // dynamic

    bodyDef.position.set(Std.int(x) / physScale, Std.int(y) / physScale);
    bodyShape.setAsBox(sprite.scaledWidth / physScale, sprite.scaledHeight / physScale / 2);
    bodyFixture = new B2FixtureDef ();
    bodyFixture.shape = bodyShape;
  }

  public override function update() {
    super.update();

    var pos:B2Vec2 = body.getPosition();


    this.x = pos.x * physScale;
    this.y = pos.y * physScale;

    if (this.y > HXP.height) {
      pos.y = -20 + HXP.scene.camera.y - HXP.halfHeight;
      body.setPosition(pos);
    }
  }
}
