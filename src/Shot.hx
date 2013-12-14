import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.prototype.Rect;
import flash.geom.Point;
import flash.geom.Rectangle;
 
class Shot extends Entity
{
	static var ShotHeight = 4;
	static var MinShotLength = 4;

    public function new(x:Float, y:Float)
    {
        super(0, 0);
        moves = new Array<Point>();
        moves.push(new Point(x, y));
        canvas = new Canvas(640, 480);
        addGraphic(canvas);
        aimGraphic = Image.createRect(1, ShotHeight, 0xFF0000);
        addGraphic(aimGraphic);
        aimGraphic.visible = false;
        aimVisible = true;
        aim = new Point(x, y);
    }

    public function setAimVisible(visible:Bool)
    {
        aimVisible = visible;
    }

    public function lockAim()
    {
    	if (aimGraphic.scaleX < MinShotLength)
    	{
    		return;
    	}

    	moves.push(aim);
    	aim = new Point();
    	canvas.drawGraphic(0, 0, aimGraphic);
    	aimGraphic.visible = false;
    }

    public function popAim()
    {
        if (moves.length > 1)
        {
            canvas.fill(new Rectangle(0,0,canvas.width, canvas.height), 0x000000, 0);
            moves.pop();
            for (i in 1...moves.length) {
                drawLine(moves[i - 1], moves[i]);
            }
            updateAim(aim.x, aim.y);
        }
    }

    public function updateAim(x:Float, y:Float)
    {
    	var last = moves[moves.length - 1];
    	aim.x = x; aim.y = y;
    	var width = Point.distance(last, aim);
    	aimGraphic.scaleX = width;
    	aimGraphic.originY = Math.floor(ShotHeight / 2);
    	aimGraphic.angle = HXP.angle(last.x, last.y, aim.x, aim.y);
    	aimGraphic.visible = aimVisible && MinShotLength < width;
    	aimGraphic.x = last.x;
    	aimGraphic.y = last.y;
    }

    function drawLine(p1:Point, p2:Point)
    {
        var width = Point.distance(p1, p2);
        aimGraphic.scaleX = width;
        aimGraphic.originY = Math.floor(ShotHeight / 2);
        aimGraphic.angle = HXP.angle(p1.x, p1.y, p2.x, p2.y);
        aimGraphic.visible = true;
        aimGraphic.x = p1.x;
        aimGraphic.y = p1.y;
        canvas.drawGraphic(0,0, aimGraphic);
    }

	public var moves:Array<Point>;
	var canvas:Canvas;
	var aimGraphic:Image;
	var aim:Point;
    var aimVisible:Bool;
}