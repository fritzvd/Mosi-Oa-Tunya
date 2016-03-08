package;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;

class Mountain extends Entity {

  public var map:Array<Array<Int>>;
  private var _tilemap:Tilemap;
  private var sizeX:Int;
  private var sizeY:Int;

  public function new (x:Int, y:Int) {
    super(x, y);
    map = [new Array<Int>()];
    sizeX = (Std.int(Math.random() * 10));
    sizeY = (Std.int(Math.random() * 10));

    if (sizeX == 0)
      sizeX = 1;
    if (sizeY == 0)
      sizeY = 1;

    name = 'mountain';

    setHitbox(sizeX, sizeY);

    _tilemap = new Tilemap('graphics/mountain.png', sizeX * 16, sizeY * 16, 16, 16);
    graphic = _tilemap;
    _tilemap.smooth = false;
    createMountain();
  }

  private function createMountain () {
    for (i in 0...sizeX) {
      if (i == 0 || i == sizeX) {
        map[0] = map[0].map(function (item) {
          var index = map[0].indexOf(item);
          if (map[0].length - 1 == index) {
            return 5;
          }
          if (index == 0) {
            return 4;
          }
          return 6;
        });
      } else {
        for (j in 0...sizeY) {
          if (map[i] == null) {
            map.insert(i, new Array<Int>());
          }
          map[i].insert(j, Std.int(Math.random() * 4));
        }
      }
    }

    trace(map);

    _tilemap.loadFrom2DArray(map);

  }
}
