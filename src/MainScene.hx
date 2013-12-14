import com.haxepunk.Scene;
import com.haxepunk.utils.Input;

class MainScene extends Scene
{

	public override function begin()
	{
		super.begin();

		player = new Contestant(100, 200);
		add(player);
		opponent = new Contestant(320, 240);
		add(opponent);
	}

	public override function update()
	{
		super.update();

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

		if (Input.check("swing"))
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
	}

	var player:Contestant;
	var opponent:Contestant;
	var swingDown:Bool;
}