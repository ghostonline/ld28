import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
 
class Bouncer extends Entity
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Rect(10, 10, 0x00FF00);
        width = 10;
        height = 10;
        type = "bouncer";
        layer = 5;
    }

    public function reset()
    {
    	targeted = false;
    }


    public var targeted:Bool;
}