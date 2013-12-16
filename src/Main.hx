import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Main extends Engine
{

	override public function init()
	{
		Input.define("move_up", [ Key.W, Key.UP ]);
		Input.define("move_down", [ Key.S, Key.DOWN ]);
		Input.define("move_left", [ Key.A, Key.LEFT ]);
		Input.define("move_right", [ Key.D, Key.RIGHT ]);
		Input.define("throw", [ Key.SPACE, Key.CONTROL, Key.X ]);
		Input.define("reset", [ Key.R, Key.ESCAPE, Key.NUMPAD_0 ]);

		HXP.screen.scaleX = 2;
		HXP.screen.scaleY = 2;
		
#if debug
		HXP.console.enable();
#end
		HXP.scene = new MainScene();
	}

	public static function main() { new Main(); }

}