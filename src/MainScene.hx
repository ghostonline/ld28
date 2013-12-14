import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import flash.geom.Point;

class MainScene extends Scene
{
	public function new()
	{
		super();
		mouseHelper = new MouseHelper(this);
	}

	function loadLevel()
	{
		bouncers = new Array<Bouncer>();
		for (i in 0...2) {
			var x = 100 + 440 * i;
			for (k in 0...2) {
				var y = 75 + k * 200;
				var bouncer = new Bouncer(x, y);
				bouncers.push(bouncer);
				add(bouncer);
			}
		}


		bottles = new Array<Bottle>();

		shooter = new Shooter(320, 440);
		add(shooter);

		maxWildCards = 1;

	}

	function shuffle(array:Array<Int>)
	{
		for (i in 0...array.length)
		{
			var swapIdx = HXP.rand(array.length - i);
			var swapNum = array[swapIdx + i];
			array[swapIdx + i] = array[i];
			array[i] = swapNum;
		}		
	}

	function generateSolution()
	{
		HXP.randomizeSeed();
		trace(HXP.randomSeed);

		var bouncersLeft = new Array<Int>();
		var bouncersRight = new Array<Int>();
		for (i in 0...Math.floor(bouncers.length / 2))
		{
			bouncersLeft.push(i);
			bouncersRight.push(i);
		}

		shuffle(bouncersLeft);
		shuffle(bouncersRight);

		var moves = new Array<Point>();
		moves.push(new Point(shooter.x, shooter.y));

		var wildCardPos = HXP.rand( bouncers.length + 1 );
		for (i in 0...bouncersLeft.length)
		{
			if (wildCardPos == i)
			{
				var endPointX = HXP.rand(440) + 100;
				var endPointY = HXP.rand(200) + 75;
				useWildCard(endPointX, endPointY);
				moves.push(new Point(endPointX, endPointY));
			}
			var left = bouncersLeft[i];
			var bouncer = bouncers[left];
			onBouncerClick(bouncer);
			moves.push(new Point(bouncer.x, bouncer.y));
			if (wildCardPos == i + 1)
			{
				var endPointX = HXP.rand(440) + 100;
				var endPointY = HXP.rand(200) + 75;
				useWildCard(endPointX, endPointY);
				moves.push(new Point(endPointX, endPointY));
			}
			var right = bouncersRight[i] + bouncersLeft.length;
			bouncer = bouncers[right];
			moves.push(new Point(bouncer.x, bouncer.y));
			onBouncerClick(bouncer);
		}
		
		if (wildCardPos == bouncers.length)
		{
			var endPointX = HXP.rand(440) + 100;
			var endPointY = HXP.rand(200) + 75;
			useWildCard(endPointX, endPointY);
			moves.push(new Point(endPointX, endPointY));
		}

		wildCards += 1;

		var endPointX = HXP.rand(440) + 100;
		var endPointY = HXP.rand(200) + 75;
		this.useWildCard(endPointX, endPointY);
		moves.push(new Point(endPointX, endPointY));

		shot.setAimVisible(false);
		for (bottle in bottles)
		{
			remove(bottle);
		}
		bottles = new Array<Bottle>();
		for (i in 1...moves.length) {
			var start = moves[i - 1];
			var stop = moves[i];
			var bottlePos = Point.interpolate(start, stop, HXP.random);
			var bottle = new Bottle(bottlePos.x, bottlePos.y);
			bottles.push(bottle);
			add(bottle);
		}
	}
	
	public override function begin()
	{
		loadLevel();
		reset();
	}

	function reset()
	{
		for (bouncer in bouncers) {
			bouncer.reset();
		}
		for (bottle in bottles) {
			bottle.reset();
		}

		wildCards = maxWildCards;

		if (shot != null)
		{
			remove(shot);
			shot = null;
		}

		touchedBouncers = new Array<Bouncer>();

		mouseHelper.clickTargetType = "shooter";
		mouseHelper.onTargetClicked = function(e:Entity) { start(); }
		mouseHelper.onEmptyClick = null;

		revertAimHot = false;
		start();
		generateSolution();
	}

	function start()
	{
		shot = new Shot(shooter.x, shooter.y);
		add(shot);

		mouseHelper.clickTargetType = "bouncer";
		mouseHelper.onTargetClicked = onBouncerClick;
		mouseHelper.onEmptyClick = useWildCard;
	}

	function onBouncerClick(e:Entity)
	{
		var bouncer = cast(e, Bouncer);
		if (!bouncer.targeted)
		{
			bouncer.targeted = true;
			shot.updateAim(bouncer.x, bouncer.y);
			shot.lockAim();
			touchedBouncers.push(bouncer);
		}
	}

	function useWildCard(x:Int, y:Int)
	{
		if (wildCards > 0)
		{
			wildCards -= 1;
			shot.updateAim(x, y);
			shot.lockAim();
			touchedBouncers.push(null);
		}
	}

	function revertAim()
	{
		if (touchedBouncers.length == 0)
		{
			return;
		}

		shot.popAim();
		var bouncer = touchedBouncers.pop();
		if (bouncer != null)
		{
			bouncer.reset();
		}
		else
		{
			wildCards += 1;
		}
	}

	function fire()
	{
		shot.lockAim();
		bullet = new Bullet(shot.moves);
		add(bullet);
		remove(shot);
		shot = null;

		mouseHelper.onTargetClicked = null;
		mouseHelper.onEmptyClick = null;
	}

	public override function update()
	{
		super.update();
		if (shot != null)
		{
			shot.updateAim(Input.mouseX, Input.mouseY);
			if (Input.check("abort_aim"))
			{
				revertAimHot = true;
			}
			else if (Input.check("fire"))
			{
				fire();
			}
			else if (revertAimHot)
			{
				revertAim();
				revertAimHot = false;
			}
			else
			{
				revertAimHot = false;
			}
		}

		if (Input.check("reset"))
		{
			resetHot = true;
		}
		else if (resetHot)
		{
			resetHot = false;
			reset();
		}
		mouseHelper.update();

	}

	var bouncers:Array<Bouncer>;
	var bottles:Array<Bottle>;
	var mouseHelper:MouseHelper;
	var shooter:Shooter;
	var shot:Shot;
	var bullet:Bullet;
	var wildCards:Int;
	var maxWildCards:Int;
	var resetHot:Bool;
	var revertAimHot:Bool;
	var touchedBouncers:Array<Bouncer>;
}