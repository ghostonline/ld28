import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.utils.Input;


class Shooter extends Entity
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        graphic = new Circle(10, 0xFF0000);
        mask = new com.haxepunk.masks.Circle(10);
        type = "shooter";
    }
}