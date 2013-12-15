import com.haxepunk.Scene;
import com.haxepunk.utils.Input;

class MainScene extends Scene
{
	static var shrinkInterval = 5;

	public override function begin()
	{
		super.begin();

		arena = new Arena(16, 112, 288, 112);
		add(arena);
		com.haxepunk.HXP.alarm(shrinkInterval, shrinkArena, Looping);
		spawnPlayer();
		spawnOpponent();
		add(new Background());
	}

	function shrinkArena(Void):Void
	{
		arena.dropSides();
	}

	function spawnPlayer()
	{
		player = new Contestant(50, 120, 3, 0.15, arena, 0xFF9999);
		add(player);
	}

	function spawnOpponent()
	{
		opponent = new Contestant(160, 120, 1, 0.3, arena, 0x3333FF);
		opponent.defeated = spawnOpponent;
		add(opponent);
		ai = new AgressiveAI(opponent, player);
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

		ai.updateAI();
	}

	var player:Contestant;
	var opponent:Contestant;
	var swingDown:Bool;
	var ai:AgressiveAI;
	var arena:Arena;
}