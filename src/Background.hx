import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Tilemap;
 
class Background extends Entity
{
    public function new()
    {
        super(0,0);
        tilemap = new Tilemap("graphics/fence.png", 320, 256, 32, 32);
        for (i in 0...tilemap.columns) {
        	var offset = 0;
        	if (i % 2 == 1)
        	{
        		offset = 1;
        	}
        	tilemap.setTile(i,1,0 + offset);
        	tilemap.setTile(i,2,2 + offset);
        	for(j in 0...tilemap.rows - 3)
        	{
        		tilemap.setTile(i,3 + j,4 + offset);
        	}
        }
        addGraphic(tilemap);
        var image = new Image("graphics/warning.png");
        image.x = 16;
        image.y = 75;
        addGraphic(image);
        layer = 200;
    }

    var tilemap:Tilemap;
}