import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.utils.Ease;
 
private class FloorDrop
{
	public var images:Array<Image>;
	public var tween:LinearMotion;

	public function new(images:Array<Image>, tween:LinearMotion)
	{
		this.images = images;
		this.tween = tween;
	}
}

class Arena extends Entity
{
	static var tileWidth = 24;
	static var tileHeight = 16;
	static var fallSpeed = 128;
	static var fallSpeedFalloff = 4;

    public function new(x:Float, y:Float, width:Int, height:Int)
    {
        super(x, y);
        ground = new Array<Image>();
        columns = Math.floor(width / tileWidth);
        rows = Math.floor(height / tileHeight);
        for (row in 0...rows) {
        	for (col in 0...columns) {
        		var tile = Image.createRect(tileWidth, tileHeight, 0x0000FF);
        		tile.x = col * tileWidth;
        		tile.y = row * tileHeight;
        		ground.push(tile);
        		addGraphic(tile);
        	}
        }
        setHitbox(width, height);
        drop = new Array<FloorDrop>();
        layer = 99;
    }

    public function dropSides()
    {
    	if (columns - reduced * 2 <= 2)
    		return;

    	for (i in 0...rows) {
    		var leftIdx = i * columns + reduced;
    		var rightIdx = i * columns + (columns - reduced - 1);
    		var leftTile = ground[leftIdx];
    		var rightTile = ground[rightIdx];
	    	var tween = new LinearMotion();
	    	tween.setMotionSpeed( 0 , leftTile.y , 0 , 320 , fallSpeed - fallSpeedFalloff * HXP.random, Ease.quadIn );
	    	addTween(tween);
	    	var tiles = new Array<Image>();
	    	tiles.push(leftTile);
	    	tiles.push(rightTile);
	    	var newDrop = new FloorDrop(tiles, tween);
	    	drop.push(newDrop);
    	}
    	reduced += 1;
    }

    public override function update()
    {
        super.update();
        for (d in drop)
        {
        	if (d.tween.active)
        	{
        		for (tile in d.images)
        		{
        			tile.y = d.tween.y;
        		}
        	}
        }
    }

    var ground:Array<Image>;
    var columns:Int;
    var rows:Int;
    var reduced:Int;
    var drop:Array<FloorDrop>;
}