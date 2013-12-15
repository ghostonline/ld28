import com.haxepunk.Entity;
import com.haxepunk.HXP;

class AgressiveAI
{
	static var swingRangeThreshold = 16;

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
		var dist = HXP.distance(contestant.x, contestant.y, target.x, target.y);
		if (dist < swingRangeThreshold)
		{
			contestant.setAimDirection(aimX, aimY);
			contestant.swing();
		}
	}

	var target:Entity;
	var contestant:Contestant;
}