import com.haxepunk.Entity;
import com.haxepunk.HXP;

class AgressiveAI
{
	static var swingRangeThresholdX = 24;
	static var swingRangeThresholdY = 16;

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
		contestant.setAimDirection(aimX, aimY);
		if (Math.abs(aimX) < swingRangeThresholdX && Math.abs(aimY) < swingRangeThresholdY)
		{
			contestant.swing();
		}
	}

	var target:Entity;
	var contestant:Contestant;
}