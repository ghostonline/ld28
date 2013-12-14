import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
 
class Weapon extends Entity
{
	static var turnAroundFactor = 2;

    public function new(x:Float, y:Float, dX:Float, dY:Float, throwSpeed:Float, image:Image, range:Float, strength:Float, owner:Contestant)
    {
        super(x, y);
        this.image = image;
        this.range = range;
        this.strength = strength;
        this.owner = owner;
        moveX = dX * throwSpeed;
        moveY = dY * throwSpeed;
        dAngle = turnAroundFactor * throwSpeed;
        graphic = image;
        image.x = 0;
        image.y = 0;
        image.centerOrigin();
        image.visible = true;
        var halfWidth = Math.floor(image.width / 2);
        mask = new com.haxepunk.masks.Circle(halfWidth, -halfWidth, -halfWidth);
    }

    public override function update()
    {
        super.update();
        moveBy(moveX, moveY, "contestant");
        image.angle += dAngle;
    }

    public override function moveCollideX(e:Entity)
    {
    	if (e == owner)
    	{
    		return false;
    	}

    	var contestant = cast(e, Contestant);
    	var angle = com.haxepunk.HXP.angle(x, y, e.x, e.y);
    	contestant.receiveSwing( angle , strength );
    	moveX = 0;
    	moveY = 0;
    	dAngle = 0;
    	return true;
    }

    public override function moveCollideY(e:Entity)
    {
    	return moveCollideX(e);
    }

    var dAngle:Float;
    var moveX:Float;
    var moveY:Float;
    var image:Image;
    var range:Float;
    var strength:Float;
    var owner:Contestant;
}