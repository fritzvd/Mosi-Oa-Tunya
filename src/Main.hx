package;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;

class Main extends Engine
{

	override public function init()
	{
#if debug
		HXP.console.enable();
#end

		var music = new Sfx("audio/mosi.ogg");
		music.loop(0.5);

		HXP.scene = new MainScene();
	}

	public static function main() { new Main(); }
}
