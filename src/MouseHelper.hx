import com.haxepunk.Entity;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;

class MouseHelper
{
    public function new(scene:Scene)
    {
        this.scene = scene;
    }

    public function update()
    {
        if (onTargetClicked != null && clickTargetType != null)
        {
	        if (Input.mousePressed)
	        {
		        var entity = scene.collidePoint(clickTargetType, Input.mouseX, Input.mouseY);
		        if (entity != null)
		        {
		        	hotEntity = entity;
		        }
		        else
		        {
		        	hotEmpty = onEmptyClick != null;
		        }
	    	}
	    	else if (Input.mouseReleased && (hotEntity != null || hotEmpty))
	    	{
		        var entity = scene.collidePoint(clickTargetType, Input.mouseX, Input.mouseY);
		        if (entity != null && entity == hotEntity)
		        {
		        	onTargetClicked(entity);
		        }
		        else if(hotEmpty)
		        {
		        	onEmptyClick(Input.mouseX, Input.mouseY);
		        }
	        	hotEntity = null;
	        	hotEmpty = false;
	        }
    	}
    }

	public var clickTargetType:String;
	public var onTargetClicked:Entity->Void;
	public var onEmptyClick:Int->Int->Void;
    var scene:Scene;
    var hotEntity:Entity;
    var hotEmpty:Bool;
}