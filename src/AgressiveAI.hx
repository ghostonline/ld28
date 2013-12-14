import com.haxepunk.Entity;

class AgressiveAI
{
	public function new(contestant:Contestant, target:Contestant)
	{
		this.target = target;
		this.contestant = contestant;
	}

	public function updateAI()
	{
		var aimX = Math.floor(target.x - contestant.x);
		var aimY = Math.floor(target.y - contestant.y);
		contestant.setMoveDirection(aimX, aimY);
	}

	var target:Entity;
	var contestant:Contestant;
}