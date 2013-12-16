import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
 
class HitPrompt extends Entity
{
    public function new(overlay:String, entity:Entity, offsetX:Float, offsetY:Float)
    {
        super(0, 0);
        text = new Text(overlay, 0, 0, { size : 8, color : 0xFFFFFF });
        var background = Image.createRect(text.width, text.height, 0x000000, 0.5);
        addGraphic(background);
        addGraphic(text);

        this.offsetX = offsetX;
        this.offsetY = offsetY;
        this.entity = entity;
    }

    function updatePlace()
    {
    	x = entity.x + offsetX;
    	y = entity.y + offsetY;
    }

    public function hide()
    {
        scene.remove(this);
    }

    public override function update()
    {
        super.update();
        updatePlace();
    }

    var text:Text;
    var offsetX:Float;
    var offsetY:Float;
    var entity:Entity;
}