import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Main extends Engine
{

	override public function init()
	{
		Input.define("abort_aim", [ Key.ESCAPE ]);
		Input.define("fire", [ Key.SPACE ]);
		Input.define("reset", [ Key.R ]);

#if debug
		HXP.console.enable();
#end
		HXP.scene = new MainScene();
	}

	public static function main() { new Main(); }

}