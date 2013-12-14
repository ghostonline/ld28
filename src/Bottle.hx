import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Circle;
 
class Bottle extends Entity
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Circle(10);
        mask = new com.haxepunk.masks.Circle(12);
        type = "bottle";
    }

    public function explode()
    {
        collidable = false;
        visible = false;
    }

    public function reset()
    {
        collidable = true;
        visible = true;
    }
}