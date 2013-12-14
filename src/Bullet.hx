import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import flash.geom.Point;
import com.haxepunk.HXP;
 
class Bullet extends Entity
{
	static var BulletSpeed = 16;
    static var SampleStep = 4;

    public function new(moves:Array<Point>)
    {
        var first = moves[current];
        super(first.x, first.y);
        image = Image.createRect(16, 4, 0x666666);
        graphic = image;
        this.moves = moves;
    }

    public override function update()
    {
    	super.update();
        var step = BulletSpeed / SampleStep;
        for (i in 0...SampleStep) {
            moveStep(step);
        }
    }

    function moveStep(step:Float)
    {
        if (current < moves.length)
        {
            var currentPoint = moves[current];
            moveTowards(currentPoint.x, currentPoint.y, step);
            if (distanceToPoint(currentPoint.x, currentPoint.y) < step)
            {
                current += 1;
                if (current < moves.length)
                {
                    image.angle = HXP.angle(x, y, moves[current].x, moves[current].y);
                }
            }
        }
        else
        {
            moveAtAngle(image.angle, step);
        }
        
        var collisions = new Array<Entity>();
        collideInto("bottle", x, y, collisions);
        for (e in collisions)
        {
            var bottle = cast(e, Bottle);
            bottle.explode();
        }        
    }

    var current:Int;
    var moves:Array<Point>;
    var image:Image;
}