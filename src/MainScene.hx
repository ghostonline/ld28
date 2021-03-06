import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;

private class LevelOpponent
{
	public var speed:Float;
	public var swingDuration:Float;
	public var strength:Float;
	public var color:Int;

	public function new(speed:Float, swingDuration:Float, strength:Float, color:Int)
	{
		this.speed = speed;
		this.swingDuration = swingDuration;
		this.strength = strength;
		this.color = color;
	}
}

class MainScene extends Scene
{
	static var shrinkInterval = 25;
	static var levels:Array<LevelOpponent> = null;
	static var opponentsPerLevel = 3;
	static var spawn:Array<Int> = [168, 136, 200];

	public function new(startDirectly = false)
	{
		super();
		this.startDirectly = startDirectly;
	}

	public override function begin()
	{
		super.begin();
		if (levels == null)
		{
			loadLevels();
		}

		arena = new Arena(16, 112, 288, 112);
		add(arena);
		add(new Background());
		counter = new Counter(295, 84);
		add(counter);
		defeatCount = -1;
		counter.setCount(0);
		title = new Title();
		explanationOverlay = new HitPrompt("Controls:\n\n\tWASD or arrow keys\t\t- Move\n\tMouse move\t\t\t\t- Aim\n\tLeft mouse button\t\t\t- Swing bat\n\tSpace, Ctrl or Numpad-0\t- Throw bat\n\nRemember: you only get one bat, do not lose it!\n\n\t\t\t\t(click to continue)", title, 55, 120);
		if (!startDirectly)
		{
			add(title);
			add(explanationOverlay);
		}
		else
		{
			startIntro();
		}
	}

	function startIntro()
	{
		title.hide();
		remove(explanationOverlay);
		explanationOverlay = null;
		spawnPlayer();
		spawnStartGamePawn();
	}

	function loadLevels()
	{
		levels = new Array<LevelOpponent>();
		levels.push(new LevelOpponent(1, 0.3, 3, 0xFFFF00)); // Yellow	
		levels.push(new LevelOpponent(1, 0.3, 6, 0x808000)); // Olive	
		levels.push(new LevelOpponent(1, 0.3, 8, 0x008000)); // Green	
		levels.push(new LevelOpponent(2, 0.3, 3, 0x008080)); // Teal	
		levels.push(new LevelOpponent(2, 0.3, 6, 0x0000FF)); // Blue	
		levels.push(new LevelOpponent(3, 0.3, 6, 0x800080)); // Purple	
		levels.push(new LevelOpponent(3, 0.3, 6, 0x800000)); // Maroon	
		levels.push(new LevelOpponent(3, 0.3, 8, 0x00FF00)); // Lime	
		levels.push(new LevelOpponent(3, 0.3, 10, 0x00FFFF)); // Aqua	
		levels.push(new LevelOpponent(3, 0.3, 12, 0xFF00FF)); // Fuchsia	
	}

	function shrinkArena(Void):Void
	{
		arena.dropSides();
	}

	function spawnPlayer()
	{
		player = new Contestant(50, 120, 3, 0.15, arena, 0xFF0000, 6);
		player.defeated = function() { 
			add(new GameOver());
			playerDead = true; 
		}
		add(player);
	}

	function spawnStartGamePawn()
	{
		var startPawn = new Contestant(160, 168, 3, 0.15, arena, 0xFFFFFF, 6);
		add(startPawn);
		
		startPawn.defeated = function() { 
			spawnOpponent();
			HXP.alarm(shrinkInterval, shrinkArena, Looping);
			hintOverlay.hide();
		}

		startPawn.dropDone = function() {
			hintOverlay = new HitPrompt("Whack the dummy from the board to start", startPawn, -90, 10);
			add(hintOverlay);			
		}
	}

	function spawnOpponent()
	{
		if (playerDead)
			return;

		defeatCount += 1;
		counter.setCount(defeatCount);
		var levelNum = Math.floor(defeatCount / opponentsPerLevel);
		levelNum = Math.floor(HXP.clamp(levelNum, 0, levels.length - 1));
		var levelData = levels[levelNum];

		var spawnY = spawn[0];
		if (HXP.distance(player.x, player.y, 160, spawnY) < 24)
		{
			spawnY = spawn[HXP.rand(2) + 1];
		}
		opponent = new Contestant(160, spawnY, levelData.speed, levelData.swingDuration, arena, levelData.color, levelData.strength);
		opponent.defeated = spawnOpponent;
		add(opponent);
		ai = new AgressiveAI(opponent, player);
	}

	public override function update()
	{
		super.update();
		if (explanationOverlay != null)
		{
			if (Input.mousePressed)
			{
				startIntro();
			}
			return;
		}

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

		if (Input.check("reset"))
		{
			resetPrimed = true;
		}
		else if (resetPrimed)
		{
			HXP.scene = new MainScene(true);
			resetPrimed = false;
		}
		else
		{
			resetPrimed = false;
		}

		if (ai != null)
		{
			ai.updateAI();
		}
	}

	var startDirectly:Bool;
	var player:Contestant;
	var opponent:Contestant;
	var swingDown:Bool;
	var ai:AgressiveAI;
	var arena:Arena;
	var counter:Counter;
	var defeatCount:Int;
	var playerDead:Bool;
	var resetPrimed:Bool;
	var title:Title;
	var hintOverlay:HitPrompt;
	var explanationOverlay:HitPrompt;
}