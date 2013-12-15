import com.haxepunk.Scene;
import com.haxepunk.utils.Input;

class MainScene extends Scene
{
	static var shrinkInterval = 10;

	public override function begin()
	{
		super.begin();

		player = new Contestant(50, 50, 3, 0.2);
		add(player);
		opponent = new Contestant(160, 120, 1, 0.3);
		add(opponent);
		ai = new AgressiveAI(opponent, player);
		arena = new Arena(16, 64, 288, 144);
		add(arena);
		com.haxepunk.HXP.alarm(shrinkInterval, shrinkArena, Looping);
	}

	function shrinkArena(Void):Void
	{
		arena.dropSides();
	}

	public override function update()
	{
		super.update();

		player.setAimDirection(Math.floor(Input.mouseX - player.x), Math.floor(Input.mouseY - player.y));

		var moveX = 0;
		var moveY = 0;
		if (Input.check("move_up"))
		{
			moveY -= 1;
		}
		if (Input.check("move_down"))
		{
			moveY += 1;
		}
		if (Input.check("move_left"))
		{
			moveX -= 1;
		}
		if (Input.check("move_right"))
		{
			moveX += 1;
		}
		player.setMoveDirection(moveX, moveY);

		if (Input.mousePressed)
		{
			if (!swingDown)
			{
				player.swing();
				swingDown = true;
			}
		}
		else
		{
			swingDown = false;
		}

		if (Input.check("throw"))
		{
			player.throw_();
		}

		//ai.updateAI();

	}

	var player:Contestant;
	var opponent:Contestant;
	var swingDown:Bool;
	var ai:AgressiveAI;
	var arena:Arena;
}