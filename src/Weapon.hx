import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
 
class Weapon extends Entity
{
	static var turnAroundFactor = 2;

    public function new(x:Float, y:Float, dX:Float, dY:Float, throwSpeed:Float, image:Image, range:Float, strength:Float, throwStrength:Float, owner:Contestant)
    {
        super(x, y);
        this.image = image;
        this.range = range;
        this.strength = strength;
        this.throwStrength = throwStrength;
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
        type = "weapon";
        dangerous = true;
        layer = 75;
    }

    public override function update()
    {
        super.update();
        moveBy(moveX, moveY, "contestant");
        image.angle += dAngle;
        if (x < 0 || y < 0 || x > 320 || y > 240)
        {
            scene.remove(this);
        }
    }

    public override function moveCollideX(e:Entity)
    {
    	if (e == owner)
    	{
    		return false;
    	}

    	var contestant = cast(e, Contestant);
    	var angle = com.haxepunk.HXP.angle(x, y, e.x, e.y);
    	contestant.receiveSwing( angle , throwStrength );
    	moveX = 0;
    	moveY = 0;
    	dAngle = 0;
        dangerous = false;
    	return true;
    }

    public override function moveCollideY(e:Entity)
    {
    	return moveCollideX(e);
    }

    public function pickup()
    {
        scene.remove(this);
    }


    public var dangerous:Bool;
    var dAngle:Float;
    var moveX:Float;
    var moveY:Float;
    public var image:Image;
    public var range:Float;
    public var strength:Float;
    public var throwStrength:Float;
    var owner:Contestant;
}