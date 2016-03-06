
import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;

class Mountain extends Entity {

  public var map:Array<Array<Int>>;
  private var _tilemap:Tilemap;
  private var sizeX:Int;
  private var sizeY:Int;

  public function new (x:Int, y:Int) {
    super(x, y);

    sizeX = (1 + Std.int(Math.random() * 5)) + 4;
    sizeY = (1 + Std.int(Math.random() * 5)) + 4;
    trace(sizeX, sizeY);

    _tilemap = new Tilemap('graphics/mountain.png', sizeX, sizeY, 4, 4);
    graphic = _tilemap;
    _tilemap.scale = 5;
    _tilemap.smooth = false;
    createMountain();
  }

  private function createMountain () {
    // for (i in 0...sizeX) {
    //   if (map[i] == null) {
    //     map[i] = [[]];
    //   }
    //   for (j in 0...sizeY) {
    //     map[i][j] = Std.int(Math.random() * 4);
    //   }
    // }
    map = [
    [0, 1, 0],
    [0, 2, 0],
    [3, 3, 3],
    ];
    _tilemap.loadFrom2DArray(map);

  }
}
