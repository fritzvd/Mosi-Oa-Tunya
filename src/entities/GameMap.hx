package entities;

import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

class GameMap extends Entity {

  private var tileSize:Int = 16;
  public var timesX:Int = 3;
  public var timesY:Int = 6;
  public var mapWidth:Int;
  public var mapHeight:Int;

  public function new () {
    mapWidth = Std.int(HXP.width * timesX);
    mapHeight = Std.int(HXP.height * timesY);
    super(- HXP.width, -HXP.height * 4);
    layer = 1;

		var tilemap:Tilemap = new Tilemap("graphics/tiles.png", mapWidth, mapHeight, tileSize, tileSize);

    var TILES = {
      WATER: [0, 1, 2],
      BEACH: [8, 9],
      DEAD: [0, 1, 2, 3, 4, 5, 6, 7]
    };
    var beachGrid:Grid = tilemap.createGrid(TILES.BEACH);
    var deathGrid:Grid = tilemap.createGrid(TILES.BEACH);
    trace(tilemap.columns);
		for (i in 0...tilemap.columns) {
			for (j in 0...tilemap.rows)
			{
        var tile:Int = 8;

        var shoreLineRight:Bool =  i > (tilemap.columns - 20);
        var shoreLineLeft:Bool = i < 20;
        if (shoreLineLeft || shoreLineRight) {
          if (shoreLineLeft && i == 19) {
            tile = 9;
          } else if (shoreLineRight && i == tilemap.columns - 19) {
            tile = 10;
          } else {
            tile = Std.random(7);
          }
        }
        //else {
        //  tile = TILES.WATER[0];
        // }

				if (tile != 8) {
					tilemap.setTile(i, j, tile);
					beachGrid.setTile(i, j, true);
				}
			}
		}

		// Create a new entity to use as a tilemap
	  graphic = tilemap;
		mask = beachGrid;
    this.type = 'solid';
  }
}
