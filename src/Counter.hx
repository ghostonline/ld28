import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import flash.geom.Rectangle;
 
class Counter extends Entity
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        var background = new Image("graphics/counterdisplay.png");
        background.centerOrigin();
        addGraphic(background);
        digits = new Array<Image>();
        digits.push(new Image("graphics/counter.png", new Rectangle(0,0,12,16)));
        digits[0].x = -13; digits[0].y = -8;
        addGraphic(digits[0]);
        digits.push(new Image("graphics/counter.png", new Rectangle(0,0,12,16)));
        digits[1].x = 1; digits[1].y = -8;
        addGraphic(digits[1]);
    }

    public function setCount(num:Int)
    {
    	var tens = Math.floor(num / 10);
    	var singles = num % 10;
    	digits[0].clipRect.x = tens * 12;
    	digits[0].updateBuffer();
    	digits[1].clipRect.x = singles * 12;
    	digits[1].updateBuffer();
    }

    var digits:Array<Image>;
}