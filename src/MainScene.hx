import com.haxepunk.Scene;
import com.haxepunk.utils.Input;

class MainScene extends Scene
{

	public override function begin()
	{
		super.begin();

		player = new Contestant(100, 200, 5, 0.2);
		add(player);
		opponent = new Contestant(320, 240, 3, 0.3);
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

		if (Input.mousePressed || Input.check("swing"))
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

		ai.updateAI();

	}

	var player:Contestant;
	var opponent:Contestant;
	var swingDown:Bool;
	var ai:AgressiveAI;
}