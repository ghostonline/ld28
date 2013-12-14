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
        image.centerOrigin();
        image.visible = true;
    }

    public override function update()
    {
        super.update();
        moveBy(moveX, moveY);
        image.angle += dAngle;
    }

    var dAngle:Float;
    var moveX:Float;
    var moveY:Float;
    var image:Image;
    var range:Float;
    var strength:Float;
    var owner:Contestant;
}