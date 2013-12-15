import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.tweens.misc.NumTween;
import com.haxepunk.utils.Ease;
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
        singleTween = new NumTween();
        singleTween.value = 1;
        addTween(singleTween);
        tenTween = new NumTween();
        tenTween.value = 1;
        addTween(tenTween);
    }

    public function setCount(num:Int)
    {
    	var newTens = Math.floor(num / 10);
    	var newSingles = num % 10;
    	if (newTens != tens)
    	{
    		tenTween.tween(0,1,0.5, Ease.quadOut);
    		tens = newTens;
    	}
    	if (newSingles != singles)
    	{
    		singleTween.tween(0,1,0.5, Ease.quadOut);
    		singles = newSingles;
    	}
    	digits[0].clipRect.x = tens * 12;
    	digits[0].updateBuffer();
    	digits[1].clipRect.x = singles * 12;
    	digits[1].updateBuffer();
    }

    public override function update()
    {
    	digits[0].scaleY = tenTween.value;
    	digits[0].y = -8 * tenTween.value;
    	digits[1].scaleY = singleTween.value;
    	digits[1].y = -8 * singleTween.value;
    }

    var tens:Int;
    var singles:Int;
    var tenTween:NumTween;
    var singleTween:NumTween;
    var digits:Array<Image>;
}