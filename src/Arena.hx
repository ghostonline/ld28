import com.haxepunk.Tween;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.tweens.motion.LinearMotion;
import com.haxepunk.tweens.motion.CircularMotion;
import com.haxepunk.tweens.motion.Motion;
import com.haxepunk.utils.Ease;
import flash.geom.Rectangle;
 
private class FloorDrop
{
	public var images:Array<Image>;
	public var tween:Motion;

	public function new(images:Array<Image>, tween:Motion)
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
	static var hitboxShrinkSpeed = 1;
	static var shiverDuration = 2;

    public function new(x:Float, y:Float, width:Int, height:Int)
    {
        super(x, y);
        ground = new Array<Image>();
        columns = Math.floor(width / tileWidth);
        rows = Math.floor(height / tileHeight);
        for (row in 0...rows) {
        	for (col in 0...columns) {
        		var tile = new Image("graphics/tiles.png", new Rectangle(tileWidth * HXP.rand(4), 0, tileWidth, 24));
        		tile.x = col * tileWidth;
        		tile.y = row * tileHeight;
        		ground.push(tile);
        		addGraphic(tile);
        	}
        }
        setHitbox(width, height);
        drop = new Array<FloorDrop>();
        shiver = new Array<FloorDrop>();
        layer = 99;
        type = "arena";
    }

    public function dropSides()
    {
    	if (columns - reduced * 2 <= 2)
    		return;

    	shiverTimer = shiverDuration;
    	for (i in 0...rows) {
    		var leftIdx = i * columns + reduced;
    		var leftTile = ground[leftIdx];
	    	var tween = new CircularMotion(null, TweenType.Looping);
	    	tween.setMotion(leftTile.x, leftTile.y, 1 , 90 + HXP.rand(2) * 180, true, 0.1 + 0.1 * HXP.random);
	    	addTween(tween);
	    	var newDrop = new FloorDrop([leftTile], tween);
	    	shiver.push(newDrop);

    		var rightIdx = i * columns + (columns - reduced - 1);
    		var rightTile = ground[rightIdx];
	    	tween = new CircularMotion(null, TweenType.Looping);
	    	tween.setMotion(rightTile.x, rightTile.y, 1 , 90 + HXP.rand(2) * 180, true, 0.1 + 0.1 * HXP.random);
	    	addTween(tween);
	    	var newDrop = new FloorDrop([rightTile], tween);
	    	shiver.push(newDrop);
    	}
    }

    function onShiverDone()
    {
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

    function processShivers()
    {
        for (i in 0...shiver.length)
        {
        	var idx = shiver.length - i - 1;
        	var d = shiver[idx];
    		for (tile in d.images)
    		{
    			tile.x = d.tween.x;
    		}
        }

        if (shiver.length > 0)
        {
        	shiverTimer -= HXP.elapsed;
        	if (shiverTimer < 0)
        	{
	        	for (d in shiver)
	        	{
	        		removeTween(d.tween);
	        	}
	        	shiver = new Array<FloorDrop>();
	        	onShiverDone();
        	}
        }

    }

    function processDrops()
    {
        var removables = 0;
        for (i in 0...drop.length)
        {
        	var idx = drop.length - i - 1;
        	var d = drop[idx];
        	if (d.tween.active)
        	{
        		for (tile in d.images)
        		{
        			tile.y = d.tween.y;
        		}
        	}
        	else
        	{
        		var lastIdx = drop.length - 1;
    			drop[idx] = drop[lastIdx];
    			removables += 1;
        		for (tile in d.images)
        		{
        			tile.visible = false;
        		}
        		removeTween(d.tween);
        	}
        }

        for (i in 0...removables)
        {
        	drop.pop();
        }
    }

    public override function update()
    {
        super.update();
        
        processShivers();
        processDrops();

        var hitBoxWidth = (columns - reduced * 2) * tileWidth;
        if (width > hitBoxWidth)
        {
        	width -= hitboxShrinkSpeed;
        	var offsetX = Math.floor(reduced * tileWidth - (width - hitBoxWidth) * 0.5);
        	setHitbox(width, height, -offsetX, 0);
        }
    }

    var shiverTimer:Float;
    var ground:Array<Image>;
    var columns:Int;
    var rows:Int;
    var reduced:Int;
    var shiver:Array<FloorDrop>;
    var drop:Array<FloorDrop>;
}